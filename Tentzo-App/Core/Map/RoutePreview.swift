import SwiftUI
import UIKit

struct RoutePreview: View {
    @State private var retrievedImage: UIImage?
    var nombre: String
    var image: String
    
    var body: some View {
            HStack{
                if let retrievedImage = retrievedImage {
                    Image(uiImage: retrievedImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .onAppear{
                retrievePhoto(from: image)
            }
            .frame(width: 375 ,height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 5)
            .overlay{
                Text(nombre)
                    .foregroundStyle(.white)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding()
            }
        }
    
    func retrievePhoto(from image: String) {
        guard let url = URL(string: image) else {
            print("URL no válida: \(image)")
            return
        }

        // Cargar la imagen de forma asincrónica
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    retrievedImage = image
                }
            } else {
                print("Error al cargar la imagen: \(error?.localizedDescription ?? "Desconocido")")
            }
        }.resume()
    }

}



#Preview {
    RoutePreview(nombre: "Ruta 1", image: "https://firebasestorage.googleapis.com/v0/b/app-ocoyucan.appspot.com/o/Rutas%2F1.jpeg?alt=media&token=f189a9c8-6dc6-4a16-b9ed-cda6cd8a2149")
}
