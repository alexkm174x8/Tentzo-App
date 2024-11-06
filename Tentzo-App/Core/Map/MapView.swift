import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

//For map lock
struct MapViewRepresentable: UIViewRepresentable {
    var isInteractionDisabled: Bool

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.isScrollEnabled = !isInteractionDisabled
        uiView.isZoomEnabled = !isInteractionDisabled
        uiView.isRotateEnabled = !isInteractionDisabled
        uiView.isPitchEnabled = !isInteractionDisabled
    }
}


struct MapView: View {
    @StateObject private var viewModel = RoutesViewModel()

    struct Route: Identifiable {
        var id: String
        var id_ruta: String
        let nombre: String
        let distancia: String
        let tiempo: String
        let detalles: String
        let imagen: String
    }
    
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack(alignment: .bottom) {
                    MapViewRepresentable(isInteractionDisabled: isExpanded)
                        .ignoresSafeArea(.container, edges: .top)
                    
                    VStack {
                        VStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .frame(width: 35, height: 5)
                                    .foregroundStyle(Color(.lightGray))
                                    .padding(.top, 10)
                                    .opacity(0.3)
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "map.fill")
                                    .foregroundStyle(.green)
                                Text("Rutas")
                                    .font(.headline)
                                    .foregroundStyle(.green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                            
                            if viewModel.Routes.isEmpty {
                                Text("Cargando Rutas...")
                                    .foregroundColor(.gray)
                                Spacer()
                            } else {
                                ScrollView{
                                    ForEach(viewModel.Routes) { Route in
                                        NavigationLink(destination: RouteDetails(
                                            nombre: Route.nombre,
                                            distancia: Route.distancia,
                                            tiempo: Route.tiempo,
                                            detalles: Route.detalles,
                                            imagen: Route.imagen
                                        )) {
                                            RoutePreview(nombre: Route.nombre, image: Route.imagen)
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        .onAppear {
                            viewModel.cargarProductosDesdeFirestore()
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .frame(height: isExpanded ? 700 : 152, alignment: .top)
                    .background(.white)
                    .clipShape(RoundedCorner(radius: 25.0, corners: [.topLeft, .topRight]))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -10)
                    .transition(.move(edge: .bottom))
                    .gesture(
                        DragGesture()
                        .onEnded { value in
                            if value.translation.height < 50 {
                                withAnimation {
                                    isExpanded = true
                                }
                            } else if value.translation.height > 30 {
                                withAnimation {
                                    isExpanded = false
                                }
                            }
                        }
                    )
                }
                Spacer()
            }
        }
    }
}

class RoutesViewModel: ObservableObject {
    @Published var Routes: [MapView.Route] = []

    func cargarProductosDesdeFirestore() {
        let db = Firestore.firestore()
        print("Iniciando carga de rutas desde Firestore...")
        
        db.collection("Ruta").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al cargar rutas: \(error.localizedDescription)")
                return
            }
            
            guard let Routes = querySnapshot?.documents else {
                print("No se encontraron documentos en Firestore")
                return
            }
            
            print("Documentos obtenidos: \(Routes.count) rutas")
            
            self.Routes.removeAll()
            
            for Route in Routes {
                let data = Route.data()
                print("Procesando documento: \(Route.documentID)")
                
                if let id = data["id"] as? String,
                   let id_ruta = data["id_ruta"] as? String,
                   let nombre = data["nombre"] as? String,
                   let distancia = data["distancia"] as? String,
                   let tiempo = data["tiempo"] as? String,
                   let detalles = data["detalles"] as? String,
                   let imagen = data["imagen"] as? String {
                    
                    print("Ruta cargada: \(nombre) - \(distancia) km, \(tiempo) minutos")
                    
                    let newRoute = MapView.Route(
                        id: id,
                        id_ruta: id_ruta,
                        nombre: nombre,
                        distancia: distancia,
                        tiempo: tiempo,
                        detalles: detalles,
                        imagen: imagen
                    )
                    
                    self.Routes.append(newRoute)
                } else {
                    print("Datos incompletos para la ruta \(Route.documentID), omitiendo...")
                }
            }
        }
    }
}


#Preview {
    MapView()
}
