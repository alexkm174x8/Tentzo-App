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
    @State private var isFirstPersonViewEnabled = false // New state for first-person view
    
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
                        mapType: mapType,
                        isFirstPersonViewEnabled: isFirstPersonViewEnabled // Pass the state
                    )
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No finish point available")
                }
            } else {
                ProgressView("Cargando ruta...")
            }
            
            VStack {
                Spacer()
                Button(action: {
                    isFirstPersonViewEnabled.toggle() // Toggle first-person view when tapped
                }) {
                    Text(isFirstPersonViewEnabled ? "Stop First Person View" : "Start First Person View")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(25)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}
