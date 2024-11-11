//
//  MapViewContainer.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import SwiftUI
import MapKit

struct MapViewContainer: View {
    var id_ruta: Int
    @StateObject private var viewModel = RouteViewModel()

    var body: some View {
        ZStack {
            if let errorMessage = viewModel.errorMessage {
                return AnyView(Text(errorMessage)
                    .foregroundColor(.red)
                    .padding())
            } else if !viewModel.coordinates.isEmpty {
                guard let lastCoordinate = viewModel.coordinates.last else {
                    return AnyView(Text("No finish point available"))
                }

                let finishPoint = CLLocationCoordinate2D(latitude: lastCoordinate.latitud, longitude: lastCoordinate.longitud)

                return AnyView(MapViewForRoute(
                    coordinates: viewModel.coordinates,
                    finishPoint: finishPoint
                ).edgesIgnoringSafeArea(.all))
            } else {
                return AnyView(ProgressView("Cargando ruta..."))
            }
        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}

