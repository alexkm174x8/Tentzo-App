import SwiftUI
import UIKit

struct CameraView: View {
    @State private var isImagePickerPresented: Bool = false
    @State private var image: UIImage? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                } else {
                    Text("No image selected")
                        .padding()
                }
                
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Open Camera")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Camera")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $image)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera // Abre la cámara
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Aquí puedes actualizar la vista del controlador si es necesario
    }
}

#Preview {
    CameraView()
}
