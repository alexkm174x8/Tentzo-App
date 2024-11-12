//
//  MapViewPreview.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 11/11/24.
//


import SwiftUI
import MapKit

struct MapViewPreview: View {
    var id_ruta: Int
    @StateObject private var viewModel = RouteViewModel()
    
    @State private var mapType: MKMapType = .hybrid
    
    var body: some View {
        ZStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.coordinates.isEmpty {
                if let lastCoordinate = viewModel.coordinates.last {
                    let finishPoint = CLLocationCoordinate2D(latitude: lastCoordinate.latitud, longitude: lastCoordinate.longitud)
                    
                    MapViewForRoute(
                        coordinates: viewModel.coordinates,
                        finishPoint: finishPoint,
                        mapType: mapType
                    )
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No finish point available")
                }
            } else {
                ProgressView("Cargando ruta...")
            }
        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}
