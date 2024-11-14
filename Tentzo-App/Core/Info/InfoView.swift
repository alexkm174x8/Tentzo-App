import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct InfoView: View {
    @StateObject private var viewModel = ActividadViewModel()
    @AppStorage("uid") var userID: String = ""
    @State private var showLogoutConfirmation = false // State to control the display of the confirmation alert
    
    struct Actividad: Identifiable {
        var id: String
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
                    VStack {
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
                
                ScrollView {
                    if viewModel.actividades.isEmpty {
                        Text("Cargando actividades...")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        ForEach(viewModel.actividades) { actividad in
                            NavigationLink(destination: EventsDetails(
                                nombre: actividad.nombre,
                                costo: actividad.costo,
                                detalles: actividad.detalles,
                                fecha: actividad.fecha,
                                imagen: actividad.imagen,
                                tipo: actividad.tipo
                            )) {
                                ActivityPreview(nombre: actividad.nombre, image: actividad.imagen)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showLogoutConfirmation = true // Show the confirmation alert when button is clicked
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text("Cerrar Sesión y Salir")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.red)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
                }
                .padding()
                .alert(isPresented: $showLogoutConfirmation) {
                    Alert(
                        title: Text("Confirmación"),
                        message: Text("¿Estás seguro de que quieres cerrar sesión?"),
                        primaryButton: .destructive(Text("Cerrar Sesión"), action: logOutUser),
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                }
            }
            .onAppear {
                viewModel.cargarProductosDesdeFirestore()
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
    
    private func logOutUser() {
        do {
            try Auth.auth().signOut()
            userID = ""
            // Navigate to the login screen or update the UI state as needed
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
class ActividadViewModel: ObservableObject {
    @Published var actividades: [InfoView.Actividad] = []
    
    func cargarProductosDesdeFirestore() {
        let db = Firestore.firestore()
        
        db.collection("Actividad").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documentos = querySnapshot?.documents else {
                return
            }
            
            self.actividades.removeAll()
            
            for documento in documentos {
                let data = documento.data()
                
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
                }
            }
        }
    }
}
#Preview {
    InfoView()
}

