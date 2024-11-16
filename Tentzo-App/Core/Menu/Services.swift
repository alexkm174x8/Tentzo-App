import SwiftUI
import FirebaseFirestore
import FirebaseFirestore

struct Planta: Identifiable, Decodable {
    @DocumentID var id: String?
    var imagen: String
    var nomCientifico: String
}

class PlantaViewModel: ObservableObject {
    @Published var planta: Planta?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore()
    
    init() {
        fetchRandomPlanta()
    }
    
    func fetchRandomPlanta() {
        isLoading = true
        errorMessage = nil
        
        db.collection("Planta").getDocuments { [weak self] (snapshot, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Error fetching Planta: \(error.localizedDescription)"
                    print("Error fetching Planta: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    self?.errorMessage = "No Planta documents found"
                    print("No Planta documents found")
                    return
                }
                
                let randomIndex = Int.random(in: 0..<documents.count)
                let randomDocument = documents[randomIndex]
                
                do {
                    let planta = try randomDocument.data(as: Planta.self)
                    self?.planta = planta
                } catch {
                    self?.errorMessage = "Error decoding Planta: \(error.localizedDescription)"
                    print("Error decoding Planta: \(error)")
                }
            }
        }
    }
}

struct Services: View {
    @StateObject private var viewModel = PlantaViewModel()
    
    private let imageWidth: CGFloat = 270
    private let imageHeight: CGFloat = 150
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            VStack(alignment: .center, spacing: 15) {
                Text("Especie Destacada")
                    .bold()
                    .font(.system(size: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 14)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: imageWidth, height: imageHeight)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .frame(width: imageWidth, height: imageHeight)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                } else if let planta = viewModel.planta, let imageUrl = URL(string: planta.imagen) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: imageWidth, height: imageHeight)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageWidth, height: imageHeight)
                                .clipped()
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageWidth, height: imageHeight)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth, height: imageHeight)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                }
                
                if let planta = viewModel.planta {
                    Text("Nombre científico: \(planta.nomCientifico)")
                        .bold()
                        .font(.system(size: 15))
                        .padding(.top, 5)
                        .multilineTextAlignment(.center)
                } else if viewModel.isLoading {
                    Text("Cargando...")
                        .bold()
                        .font(.system(size: 15))
                        .padding(.top, 5)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom, .trailing], 10)
        }
    }
}

struct Services_Previews: PreviewProvider {
    static var previews: some View {
        Services()
    }
}

