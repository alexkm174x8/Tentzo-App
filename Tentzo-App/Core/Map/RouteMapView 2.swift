//
//  RouteMapView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//


import SwiftUI
import MapKit
import FirebaseFirestore

struct RouteMapView: View {
    var idRuta: Int // ID of the route to fetch coordinates for
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: routeCoordinates) { coordinate in
            MapPin(coordinate: coordinate)
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
                
                // Map documents to coordinates
                routeCoordinates = documents.compactMap { document -> CLLocationCoordinate2D? in
                    let data = document.data()
                    guard let latitude = data["latitud"] as? Double,
                          let longitude = data["longitud"] as? Double else { return nil }
                    
                    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                // Update the region to the first coordinate if available
                if let firstCoordinate = routeCoordinates.first {
                    region.center = firstCoordinate
                }
            }
    }
}
