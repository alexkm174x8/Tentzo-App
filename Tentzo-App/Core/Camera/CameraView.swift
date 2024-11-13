import SwiftUI
import AVFoundation
import Photos
import PhotosUI
import UIKit

// Plant Info response model (simplified to only extract the name)
struct PlantAPI: Codable {
    struct Plant: Codable {
        let commonName: String?  // The common name of the plant
        let scientificName: String?  // The scientific name of the plant
    }

    let id: Int
    let plant: Plant
}

// API Request function to fetch plant info from the Plant.id API
// Helper function to append string data as Data
extension Data {
    mutating func append(_ string: String) {
        if let stringData = string.data(using: .utf8) {
            append(stringData)
        }
    }
}

// API Request function to fetch plant info from the Plant.id API
func getPlantInfo(from imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "https://api.plant.id/v2/identify") else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Set your API key here
    let apiKey = "YOUR_PLANT_ID_API_KEY"  // Replace with your actual API key
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    
    // Construct the multipart form data
    var body = Data()
    
    // Add boundary string to body
    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    // Add image data to body
    body.append("--\(boundary)\r\n")
    body.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"image.jpg\"\r\n")
    body.append("Content-Type: image/jpeg\r\n\r\n")
    body.append(imageData)  // Append the image data itself
    body.append("\r\n")
    
    // Add closing boundary
    body.append("--\(boundary)--\r\n")
    
    request.httpBody = body
    
    // Perform the network request
    let session = URLSession.shared
    session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        
        // Parse the response JSON to extract the plant name (common or scientific)
        do {
            let plantInfo = try JSONDecoder().decode(PlantAPI.self, from: data)
            if let commonName = plantInfo.plant.commonName {
                completion(.success(commonName))  // Return the common name
            } else if let scientificName = plantInfo.plant.scientificName {
                completion(.success(scientificName))  // Return the scientific name if the common name is unavailable
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No plant name found"])))
            }
            
            //Hola Kong, t quiero muxo
            
        } catch {
            completion(.failure(error))
        }
    }.resume()
}



// CameraModel class that handles photo capture and interaction with Plant.id API
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    @Published var plantName: String?  // Store the plant name (common or scientific)

    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                } else {
                    DispatchQueue.main.async {
                        self.alert = true
                    }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.alert = true
            }
        @unknown default:
            break
        }
    }

    func setUp() {
        do {
            self.session.beginConfiguration()

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                print("No front camera available")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            } else {
                print("Could not add input")
            }
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            } else {
                print("Could not add output")
            }
            self.session.commitConfiguration()

            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        } catch {
            print("Error during setup: \(error.localizedDescription)")
        }
    }

    func takePic() {
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            self.output.capturePhoto(with: settings, delegate: self)
        }
    }

    func reTake() {
        DispatchQueue.main.async {
            withAnimation {
                self.isTaken = false
                self.isSaved = false
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Error: Could not get image data from photo")
            return
        }
        
        DispatchQueue.main.async {
            self.picData = imageData
            withAnimation {
                self.isTaken = true
            }
            
            // Call the Plant.id API to get the plant name
            getPlantInfo(from: imageData) { result in
                switch result {
                case .success(let plantName):
                    // Handle the plant name response
                    self.plantName = plantName  // Set the plant name
                    print("Plant Name: \(plantName)")
                case .failure(let error):
                    print("Error getting plant info: \(error.localizedDescription)")
                }
            }
        }
    }
}

// SwiftUI view to display camera preview and plant name
struct CameraView: View {
    @StateObject var camera = CameraModel()
    @State private var showSaveAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
                .opacity((camera.isTaken || selectedImage != nil) ? 0 : 1)
            
            if camera.isTaken && selectedImage == nil {
                ImageView(imageData: camera.picData)
                    .transition(.opacity)
            }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all, edges: .all)
                    .transition(.opacity)
            }

            VStack {
                HStack {
                    if camera.isTaken || selectedImage != nil {
                        Button(action: {
                            if selectedImage != nil {
                                selectedImage = nil
                                camera.isSaved = false
                            } else {
                                camera.reTake()
                            }
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.leading, 25)
                        .transition(.move(edge: .leading))
                    }
                    Spacer()
                }
                Spacer()

                // Display the plant name
                if let plantName = camera.plantName {
                    Text("Plant Name: \(plantName)")
                        .font(.title)
                        .padding()
                } else {
                    Text("No plant name detected")
                        .font(.subheadline)
                        .padding()
                }

                HStack {
                    Button(action: camera.takePic, label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 75, height: 75)
                        }
                    })

                    Button(action: {
                        showPhotoPicker = true
                    }, label: {
                        Image(systemName: "photo.on.rectangle")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                    .padding(.leading)
                    .sheet(isPresented: $showPhotoPicker) {
                        PhotoPicker(selectedImage: $selectedImage, isPresented: $showPhotoPicker)
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear {
            camera.check()
        }
    }
}

// CameraPreview for showing camera input
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.bounds
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// ImageView to display the captured image
struct ImageView: View {
    let imageData: Data

    var body: some View {
        Group {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all, edges: .all)
            } else {
                Text("Error displaying image")
                    .foregroundColor(.white)
            }
        }
    }
}

// PhotoPicker for selecting images from the photo library
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false

            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.parent.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
