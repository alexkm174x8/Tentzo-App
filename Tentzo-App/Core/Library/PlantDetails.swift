import SwiftUI

struct PlantDetails: View {
    @State private var retrievedImage: UIImage?
    
    var id: String
    let nomComun: String
    let nomCientifico: String
    let familia: String
    let genero: String
    let sinonimo : String
    let descripcion: String
    let imagen: String
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                if let retrievedImage = retrievedImage {
                    Image(uiImage: retrievedImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    ProgressView()
                }                
            }.onAppear {
                retrievePhoto(from: imagen)
            }
            
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 420, height: 550)
                        .overlay(
                            
                            VStack(alignment: .leading, spacing: 20) {

                                VStack(alignment: .leading, spacing: 5) {
                                    if nomComun != "" {
                                        Text(nomCientifico)
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(red: 127/255, green: 194/255, blue: 151/255))
                                        
                                        Text(nomComun)
                                            .font(.system(size: 30))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                    } else {
                                        Text(nomCientifico)
                                            .font(.system(size: 30))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                    }
                                    
                                }
                                .frame(alignment: .leading)
                                .padding(.leading, 20)
                                
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        VStack(alignment: .leading) {
                                            Text("Descripcion")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .padding(.top, 0)

                                            Text(descripcion)
                                                .font(.system(size: 18))
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxHeight: 300)
                                
                                Spacer()
                            }
                            .padding(.top, 30)
                        )
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar(.hidden, for: .tabBar)
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
    PlantDetails(id: "1", nomComun: "Flor", nomCientifico: "Florencius", familia: "Florera", genero: "Floral", sinonimo: "Floriponcia", descripcion: "Es una flor", imagen: "flor")
}
