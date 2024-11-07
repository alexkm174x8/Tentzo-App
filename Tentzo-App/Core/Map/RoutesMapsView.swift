import SwiftUI
import MapKit
import FirebaseFirestore

// Custom struct to wrap CLLocationCoordinate2D and conform to Identifiable
struct RouteCoordinate: Identifiable {
    let id = UUID() // Unique ID for each coordinate
    let coordinate: CLLocationCoordinate2D
}

struct RoutesMapsView: View {
    var idRuta: Int // ID of the route to fetch coordinates for
    @State private var routeCoordinates: [RouteCoordinate] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: routeCoordinates) { routeCoordinate in
            MapPin(coordinate: routeCoordinate.coordinate)
        }
        .onAppear {
            fetchRouteCoordinates()
        }
    }
    
    private func fetchRouteCoordinates() {
        let db = Firestore.firestore()
        db.collection("Coordenada")
            .whereField("id_ruta", isEqualTo: idRuta)
            .order(by: "id")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching coordinates: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // Map documents to RouteCoordinate instances
                routeCoordinates = documents.compactMap { document -> RouteCoordinate? in
                    let data = document.data()
                    guard let latitude = data["latitud"] as? Double,
                          let longitude = data["longitud"] as? Double else { return nil }
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    return RouteCoordinate(coordinate: coordinate)
                }
                
                // Update the region to the first coordinate if available
                if let firstCoordinate = routeCoordinates.first?.coordinate {
                    region.center = firstCoordinate
                }
            }
    }
}

