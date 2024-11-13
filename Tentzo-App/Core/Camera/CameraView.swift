import SwiftUI
import AVFoundation
import Photos
import PhotosUI

struct CameraView: View {
    var body: some View {
        Camera()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

struct Camera: View {
    @StateObject var camera = CameraModel()
    @State private var showSaveAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            if let image = selectedImage {

                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all, edges: .all)
            } else if camera.isTaken {

                if let image = UIImage(data: camera.picData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(.all, edges: .all)
                } else {
                    Text("Error displaying image")
                        .foregroundColor(.white)
                }
            } else {

                CameraPreview(camera: camera)
                    .ignoresSafeArea(.all, edges: .all)
            }
            VStack {
                if camera.isTaken || selectedImage != nil {

                    HStack {
                        Spacer()
                        Button(action: {
                            if selectedImage != nil {
                                selectedImage = nil
                                camera.isSaved = false
                            } else {
                                camera.reTake()
                            }
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                    }
                }
                Spacer()
                HStack {
                    if camera.isTaken || selectedImage != nil {

                        Button(action: {
                            if !camera.isSaved {
                                DispatchQueue.main.async {
                                    if let imageToSave = selectedImage {
                                        saveImage(imageToSave)
                                    } else {
                                        camera.savePic { success in
                                            if success {
                                                showSaveAlert = true
                                            }
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        Spacer()
                    } else {

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
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.check()
        })

        .alert(isPresented: $camera.alert) {
            Alert(
                title: Text("Permission Denied"),
                message: Text("Please allow access to the camera and photo library in settings."),
                dismissButton: .default(Text("OK"))
            )
        }

        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Image saved successfully."),
                dismissButton: .default(Text("OK"), action: {
                    camera.isSaved = false
                })
            )
        }
    }


    func saveImage(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            if status == .authorized || status == .limited {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            camera.isSaved = true
                            showSaveAlert = true
                            print("Selected image saved successfully...")
                        } else {
                            camera.alert = true
                            print("Error saving selected image: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    camera.alert = true
                }
            }
        }
    }
}


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)


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
                print("Input added")
            } else {
                print("Could not add input")
            }
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
                print("Output added")
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
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken = false
                }
                self.isSaved = false
            }
        }
    }


    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        print("photoOutput called")
        guard let imageData = photo.fileDataRepresentation() else {
            print("Error: Could not get image data from photo")
            return
        }
        print("picData length: \(imageData.count)")
        DispatchQueue.main.async {
            self.picData = imageData
            withAnimation {
                self.isTaken = true
            }
            self.session.stopRunning()
        }
    }


    func savePic(completion: @escaping (Bool) -> Void) {
        guard !self.picData.isEmpty else {
            print("Error: picData is empty")
            DispatchQueue.main.async {
                self.alert = true
                completion(false)
            }
            return
        }
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status == .authorized || status == .limited {
            saveImageToPhotoLibrary(completion: completion)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self.saveImageToPhotoLibrary(completion: completion)
                } else {
                    DispatchQueue.main.async {
                        self.alert = true
                        completion(false)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.alert = true
                completion(false)
            }
        }
    }


    private func saveImageToPhotoLibrary(completion: @escaping (Bool) -> Void) {
        guard let image = UIImage(data: self.picData) else {
            print("Error: Could not create UIImage from picData")
            DispatchQueue.main.async {
                self.alert = true
                completion(false)
            }
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isSaved = true
                    print("Saved successfully...")
                    completion(true)
                } else {
                    self.alert = true
                    print("Error saving photo: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }
}


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

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

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
                    } else {
                        print("Error loading image from picker: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }
}

