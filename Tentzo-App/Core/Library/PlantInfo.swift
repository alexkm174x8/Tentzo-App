import SwiftUI
import FirebaseFirestore
import UIKit

struct PlantInfo: View {
    @State private var retrievedImage: UIImage?
    var nomComun: String
    var imagen: String

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(red: 127/255, green: 194/255, blue: 151/255))
                .overlay {
                    Image(imagen)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }

            Text("Plant")
                .foregroundStyle(Color.black)
        }
    }

    func retrievePhoto(from image: String) {
        guard let url = URL(string: image) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                retrievedImage = image
            }
        }.resume()
    }
}

struct AsyncPlantView: View {
    let url: String

    @State private var imagen: Image? = nil
    @State private var isLoading: Bool = true

    var body: some View {
        Group {
            if let image = imagen {
                image
                    .resizable()
                    .scaledToFill()
                    .clipped() // Ajustar el recorte
            } else {
                Color.gray // Placeholder mientras carga
                    .overlay(ProgressView())
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imagen = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}


#Preview {
    PlantInfo(nomComun: "Flor", imagen: "leaf.fill")
}
