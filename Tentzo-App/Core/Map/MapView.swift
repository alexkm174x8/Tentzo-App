import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

struct OcoyucanView: View {
    let region = MKCoordinateRegion(
        // 18.9508169,-98.3177923
        center: CLLocationCoordinate2D(latitude: 18.9508169, longitude: -98.3177923),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        MapViewRepresentable(isInteractionDisabled: false, region: region)
            .frame(height: 300)
    }
}


// For map lock
struct MapViewRepresentable: UIViewRepresentable {
    var isInteractionDisabled: Bool
    var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.isScrollEnabled = !isInteractionDisabled
        uiView.isZoomEnabled = !isInteractionDisabled
        uiView.isRotateEnabled = !isInteractionDisabled
        uiView.isPitchEnabled = !isInteractionDisabled
        
        uiView.mapType = .hybrid
        uiView.setRegion(region, animated: true)
    }
}

struct MapViewHeader: View {
    var body: some View {
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
        }
    }
}

struct RoutesListView: View {
    var routes: [MapView.Route]
    
    var body: some View {
        ScrollView {
            ForEach(routes) { route in
                NavigationLink(destination: RouteDetails(
                    nombre: route.nombre,
                    distancia: route.distancia,
                    tiempo: route.tiempo,
                    detalles: route.detalles,
                    id_ruta: Int(route.id_ruta) ?? 0
                )) {
                    RoutePreview(nombre: route.nombre, image: route.imagen)
                }
            }
        }
    }
}

struct MapView: View {
    @StateObject private var viewModel = RoutesViewModel()
    
    let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 18.9508169, longitude: -98.3177923),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
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
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    MapViewRepresentable(isInteractionDisabled: false, region: region)
                        .ignoresSafeArea(.container, edges: .top)
                    
                    VStack {
                        MapViewHeader()
                        
                        if viewModel.Routes.isEmpty {
                            Text("Cargando Rutas...")
                                .foregroundColor(.gray)
                            Spacer()
                        } else {
                            RoutesListView(routes: viewModel.Routes)
                        }
                    }
                    .onAppear {
                        viewModel.cargarProductosDesdeFirestore()
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .frame(height: isExpanded ? 700 : 264, alignment: .top)
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
            
            guard let routeDocuments = querySnapshot?.documents else {
                print("No se encontraron documentos en Firestore")
                return
            }
            
            print("Documentos obtenidos: \(routeDocuments.count) rutas")
            
            DispatchQueue.main.async {
                self.Routes = routeDocuments.compactMap { doc -> MapView.Route? in
                    let data = doc.data()
                    print("Procesando documento: \(doc.documentID)")
                    
                    guard
                        let id = data["id"] as? String,
                        let id_ruta = data["id_ruta"] as? String,
                        let nombre = data["nombre"] as? String,
                        let distancia = data["distancia"] as? String,
                        let tiempo = data["tiempo"] as? String,
                        let detalles = data["detalles"] as? String,
                        let imagen = data["imagen"] as? String
                    else {
                        print("Datos incompletos para la ruta \(doc.documentID), omitiendo...")
                        return nil
                    }
                    
                    print("Ruta cargada: \(nombre) - \(distancia) km, \(tiempo) minutos")
                    
                    return MapView.Route(
                        id: id,
                        id_ruta: id_ruta,
                        nombre: nombre,
                        distancia: distancia,
                        tiempo: tiempo,
                        detalles: detalles,
                        imagen: imagen
                    )
                }
            }
        }
    }
}

#Preview {
    MapView()
}
