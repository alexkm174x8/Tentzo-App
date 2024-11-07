//
//  RouteView 2.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//


import SwiftUI
import MapKit
import FirebaseFirestore

struct RouteMap: View {
    var routeID: Int

    @StateObject private var viewModel = RouteMapModel()

    var body: some View {
        ZStack {
            RouteMapViewRepresentable(routeCoordinates: viewModel.routeCoordinates)
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Cargando ruta...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .onAppear {
            print("RouteMap appeared with routeID: \(routeID)")
            viewModel.fetchRouteCoordinates(for: routeID)
        }
    }
}

class RouteMapModel: ObservableObject {
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var isLoading = true

    private var db = Firestore.firestore()

    func fetchRouteCoordinates(for routeID: Int) {
        db.collection("Coordenada")
            .whereField("id_ruta", isEqualTo: routeID)
            .order(by: "id") // Ensure the coordinates are in the correct order
            .getDocuments { [weak self] (querySnapshot, error) in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }

                if let error = error {
                    print("Error fetching coordinates: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No coordinates found.")
                    return
                }

                let coordinates = documents.compactMap { document -> CLLocationCoordinate2D? in
                    let data = document.data()
                    if let latitud = data["latitud"] as? Double,
                       let longitud = data["longitud"] as? Double {
                        return CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                    }
                    return nil
                }

                DispatchQueue.main.async {
                    self?.routeCoordinates = coordinates
                    print("Fetched route coordinates: \(coordinates)")
                }
            }
    }
}
