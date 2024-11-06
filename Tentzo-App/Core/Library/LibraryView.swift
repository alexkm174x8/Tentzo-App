import SwiftUI
import Firebase

struct LibraryView: View {
    @StateObject private var viewModel = PlantView()
    @State private var searchText = "" 
    
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
            // Pasar la propiedad searchText a SearchBar
            SearchBar(searchText: $searchText)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    if viewModel.plantas.isEmpty {
                        HStack(alignment: .center){
                            Text("Cargando plantas...")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else {
                        let filteredPlantas = searchText.isEmpty ? viewModel.plantas : viewModel.plantas.filter { planta in
                            planta.nomComun.lowercased().contains(searchText.lowercased()) ||
                            planta.nomCientifico.lowercased().contains(searchText.lowercased())
                        }

                        ForEach(filteredPlantas) { planta in
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

class PlantView: ObservableObject {
    @Published var plantas: [LibraryView.Planta] = []

    func cargarProductosDesdeFirestore() {
        let db = Firestore.firestore()
        
        db.collection("Planta").getDocuments { (querySnapshot, error) in
            if let error = error {
                return
            }
            
            guard let documentos = querySnapshot?.documents else {
                return
            }
            
            self.plantas.removeAll()
            
            for documento in documentos {
                let data = documento.data()

                if let id = data["id"] as? Int,
                   let nomComun = data["nomComun"] as? String,
                   let nomCientifico = data["nomCientifico"] as? String,
                   let sinonimo = data["sinonimo"] as? String,
                   let genero = data["genero"] as? String,
                   let familia = data["familia"] as? String,
                   let descripcion = data["descripcion"] as? String,
                   let imagen = data["imagen"] as? String {

                    let idString = String(id)

                    let nuevaPlanta = LibraryView.Planta(
                        id: idString,
                        nomComun: nomComun,
                        nomCientifico: nomCientifico,
                        familia: familia,
                        genero: genero,
                        sinonimo: sinonimo,
                        descripcion: descripcion,
                        imagen: imagen
                    )
                    
                    self.plantas.append(nuevaPlanta)
                } else {
                    // Si faltan campos, no se procesan
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

