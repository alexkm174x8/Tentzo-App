import SwiftUI
import Firebase

struct LibraryView: View {
    @StateObject private var viewModel = PlantView()
    @State private var searchText = ""
    
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
    
    private let numberOfColumns = 3
    
    var body: some View {
        NavigationStack {
            SearchBar(searchText: $searchText)
            
            ScrollView {
                if viewModel.plantas.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Cargando plantas...")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    let filteredPlantas = searchText.isEmpty ? viewModel.plantas : viewModel.plantas.filter { planta in
                        planta.nomComun.lowercased().contains(searchText.lowercased()) ||
                        planta.nomCientifico.lowercased().contains(searchText.lowercased())
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<filteredPlantas.count, id: \.self) { index in
                            if index % numberOfColumns == 0 {
                                HStack(spacing: 25) {
                                    ForEach(0..<numberOfColumns, id: \.self) { column in
                                        let currentIndex = index + column
                                        if currentIndex < filteredPlantas.count {
                                            let planta = filteredPlantas[currentIndex]
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
                                                PlantInfo(
                                                    nomComun: planta.nomComun,
                                                    imagen: planta.imagen,
                                                    nomCientifico: planta.nomCientifico
                                                )
                                            }
                                        } else {
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
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
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documentos = querySnapshot?.documents else {
                print("No documents found")
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
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

