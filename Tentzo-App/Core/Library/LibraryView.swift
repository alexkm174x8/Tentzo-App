import SwiftUI
import UIKit
import Firebase

struct LibraryView: View {
    @StateObject private var viewModel = PlantView()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    struct Planta: Identifiable {
        var id: String
        let nomComun: String
        let nomCientifico: String
        let familia: String
        let genero: String
        let sinonimo: String
        let descripcion: String
        let imagen: String
    }
    
    var body: some View {
        NavigationStack {
            SearchBar()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    if viewModel.plantas.isEmpty {
                        HStack(alignment: .center){
                            Text("Cargando plantas...")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else {
                        ForEach(viewModel.plantas) { planta in
                            NavigationLink(destination: PlantDetails(
                                id: planta.id,
                                nomComun: planta.nomComun,
                                nomCientifico: planta.nomCientifico,
                                familia: planta.familia,
                                genero: planta.genero,
                                sinonimo: planta.sinonimo,
                                descripcion: planta.descripcion,
                                imagen: planta.imagen
                            )) {
                                PlantInfo(nomComun: planta.nomComun, imagen: planta.imagen)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Biblioteca")
            .onAppear {
                viewModel.cargarProductosDesdeFirestore()
            }
        }
    }
}

// Clase para manejar el array de plantas
class PlantView: ObservableObject {
    @Published var plantas: [LibraryView.Planta] = []

    func cargarProductosDesdeFirestore() {
        let db = Firestore.firestore()
        
        db.collection("Planta").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)") // Manejo de error
                return
            }
            
            guard let documentos = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self.plantas.removeAll()
            
            for documento in documentos {
                let data = documento.data()
                
                // Asegúrate de que todos los campos estén disponibles
                if let id = data["id"] as? String,
                   let nomComun = data["nomComun"] as? String,
                   let nomCientifico = data["nomCientifico"] as? String,
                   let sinonimo = data["sinonimo"] as? String,
                   let genero = data["genero"] as? String,
                   let familia = data["familia"] as? String,
                   let descripcion = data["descripcion"] as? String,
                   let imagen = data["imagen"] as? String {
                    
                    let nuevaPlanta = LibraryView.Planta(
                        id: id,
                        nomComun: nomComun,
                        nomCientifico: nomCientifico,
                        familia: familia,
                        genero: genero,
                        sinonimo: sinonimo,
                        descripcion: descripcion,
                        imagen: imagen
                    )
                    
                    self.plantas.append(nuevaPlanta)
                }
            }
            
            print("Plantas cargadas: \(self.plantas)") // Para depurar
        }
    }
}

#Preview {
    LibraryView()
}
