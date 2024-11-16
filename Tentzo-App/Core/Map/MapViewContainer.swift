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
    @State private var isFirstPersonViewEnabled = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
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
                        isFirstPersonViewEnabled: isFirstPersonViewEnabled // Pass the state
                    )
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No finish point available")
                }
            } else {
                ProgressView("Cargando ruta...")
            }
            
            Button(action: {
                isFirstPersonViewEnabled.toggle() // Toggle first-person view
            }) {
                Text("Iniciar ruta")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 127/255, green: 194/255, blue: 151/255))
                    .cornerRadius(10)
            }
            .padding(.leading, 260)
            .padding(.top, 750)
        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}
