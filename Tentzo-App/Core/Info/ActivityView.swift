import SwiftUI

struct ActivityPreview: View {
    var nombre: String
    var image: String  // Esta será la URL de la imagen

    var body: some View {
        HStack {
            AsyncImageView(url: image) // Usamos AsyncImageView aquí
                .overlay {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 44/255, green: 85/255, blue: 48/255), Color.clear]), startPoint: .bottom, endPoint: .top))
                }
        }
        .frame(width: 375, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay {
            Text(nombre)
                .foregroundStyle(.white)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
        }
    }
}

struct AsyncImageView: View {
    let url: String

    @State private var image: Image? = nil
    @State private var isLoading: Bool = true

    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipped() // Ajustar el recorte
                    .ignoresSafeArea()
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
                    self.image = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}

#Preview {
    ActivityPreview(nombre: "Actividad Sola", image: "https://firebasestorage.googleapis.com/v0/b/app-ocoyucan.appspot.com/o/Actividades%2F5.jpeg?alt=media&token=7ba95542-db2b-4b42-a392-e487532fca56")
}
