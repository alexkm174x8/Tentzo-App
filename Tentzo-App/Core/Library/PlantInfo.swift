import SwiftUI
import FirebaseFirestore
import UIKit

struct PlantInfo: View {
    @State private var retrievedImage: UIImage?
    var nomComun: String
    var imagen: String
    var nomCientifico : String

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(red: 127/255, green: 194/255, blue: 151/255))
                .overlay {
                    if let retrievedImage = retrievedImage {
                        Image(uiImage: retrievedImage)
                            .resizable()
                            .frame(width: 85, height: 85)
                            .clipShape(RoundedCorner(radius: 23))
                    } else {
                        ProgressView()
                    }
                }

            Text(nomComun == "" ? nomCientifico : nomComun)
                .foregroundStyle(Color.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.system(size: 16))
        }
        .onAppear {
            retrievePhoto(from: imagen)
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
    PlantInfo(nomComun: "Flor", imagen: "leaf.fill", nomCientifico: "Caca")
}
