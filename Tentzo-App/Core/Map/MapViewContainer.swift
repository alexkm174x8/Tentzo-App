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
    @Environment(\.presentationMode) var presentationMode
    
    @State private var mapType: MKMapType = .hybrid
    
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
                        mapType: mapType
                    )
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No finish point available")
                }
            } else {
                ProgressView("Cargando ruta...")
            }
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 32))
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding([.top, .leading], 20)
        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}
