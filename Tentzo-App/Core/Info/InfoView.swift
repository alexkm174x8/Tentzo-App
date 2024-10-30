import SwiftUI
import Firebase
import FirebaseFirestore

struct InfoView: View {
    @StateObject private var viewModel = ActividadViewModel()

    struct Actividad: Identifiable {
        var id: String // Usar String para el ID
        let nombre: String
        let detalles: String
        let costo: String
        let fecha: String
        let tipo: String
        let imagen: String
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Redes Sociales")
                        .bold()
                        .font(.system(size: 20))
                    VStack{
                        Divider()
                    }
                }
                .padding()

                HStack(spacing: 27) {
                    Link(destination: URL(string: "https://www.facebook.com/ocoyucanvidayconservacion")!) {
                        createSocialLink(imageName: "fb_logo")
                    }
                    Link(destination: URL(string: "https://www.instagram.com/ocoyucanvidayconservacion/")!) {
                        createSocialLink(imageName: "instagram_logo")
                    }
                    Link(destination: URL(string: "https://x.com/OcoyucanVYCAC")!) {
                        createSocialLink(imageName: "x_logo")
                    }
                }
                .padding()

                Text("Mis actividades")
                    .bold()
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                if let actividad = viewModel.actividades.first {
                    NavigationLink(destination: EventsDetails(
                        nombre: actividad.nombre,
                        costo: actividad.costo,
                        detalles: actividad.detalles,
                        fecha: actividad.fecha,
                        imagen: actividad.imagen,
                        tipo: actividad.tipo
                    )) {
                        ActivityPreview(nombre: actividad.nombre)
                    }
                } else {
                    Text("Cargando actividad...")
                        .foregroundColor(.gray)
                    Spacer()
                }

                Spacer()
            }
            .onAppear {
                viewModel.cargarProductosDesdeFirestore() // Cargar datos al aparecer la vista
            }
        }
    }

    private func createSocialLink(imageName: String) -> some View {
        RoundedRectangle(cornerRadius: 30)
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
            .frame(width: 100, height: 100)
            .foregroundStyle(Color(red: 233/255, green: 244/255, blue: 202/255))
            .overlay {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
            }
    }
}

class ActividadViewModel: ObservableObject {
    @Published var actividades: [InfoView.Actividad] = []

    func cargarProductosDesdeFirestore() {
        let db = Firestore.firestore()
        
        db.collection("Actividad").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al recuperar productos: \(error.localizedDescription)")
                return
            }
            
            guard let documentos = querySnapshot?.documents else {
                print("No se encontraron productos")
                return
            }
            
            // Limpiar el array antes de agregar nuevos productos
            self.actividades.removeAll()
            
            for documento in documentos {
                let data = documento.data()
                print("Documento: \(documento.documentID) -> \(data)") // Imprime el documento completo
                
                // Crear una actividad solo si todos los datos están presentes
                if let nombre = data["nombre"] as? String,
                   let detalles = data["detalles"] as? String,
                   let costo = data["costo"] as? String,
                   let fecha = data["fecha"] as? String,
                   let tipo = data["tipo"] as? String,
                   let imagen = data["imagen"] as? String {
                    
                    let nuevaActividad = InfoView.Actividad(
                        id: documento.documentID,
                        nombre: nombre,
                        detalles: detalles,
                        costo: costo,
                        fecha: fecha,
                        tipo: tipo,
                        imagen: imagen
                    )
                    
                    self.actividades.append(nuevaActividad)
                } else {
                    print("Datos faltantes en el documento \(documento.documentID)")
                    // Imprime qué campos están faltando
                    if data["nombre"] == nil { print("Falta 'nombre'") }
                    if data["detalles"] == nil { print("Falta 'detalles'") }
                    if data["costo"] == nil { print("Falta 'costo'") }
                    if data["fecha"] == nil { print("Falta 'fecha'") }
                    if data["tipo"] == nil { print("Falta 'tipo'") }
                    if data["imagen"] == nil { print("Falta 'imagen'") }
                }
            }
            
            // Verificar el contenido del array después de cargar
            print("Actividades cargadas: \(self.actividades)")
        }
    }
}

#Preview {
    InfoView()
}
