//
//  MapViewContainer.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import SwiftUI

struct MapViewContainer: View {
    var id_ruta: Int
    @StateObject private var viewModel = RouteViewModel()

    var body: some View {
        ZStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.coordinates.isEmpty {
                MapViewForRoute(coordinates: viewModel.coordinates)
                    .edgesIgnoringSafeArea(.all)
            } else {
                ProgressView("Cargando ruta...")
            }
        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}
