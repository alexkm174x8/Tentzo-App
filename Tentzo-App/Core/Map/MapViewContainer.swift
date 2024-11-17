//
//  MapViewContainer.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//
import SwiftUI
import MapKit

struct MapViewContainer: View {
    var nombre: String
    var distancia: String
    var tiempo: String
    var detalles: String
    var id_ruta: Int
    @StateObject private var viewModel = RouteViewModel()
    @State private var isFirstPersonViewEnabled = false
    @Environment(\.dismiss) private var dismiss
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
                        isFirstPersonViewEnabled: isFirstPersonViewEnabled
                    )
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No finish point available")
                }
            } else {
                ProgressView("Cargando ruta...")
            }
            
            Button(action: {
                isFirstPersonViewEnabled.toggle() // Iniciar ruta
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
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.top, 11)
                    .padding(.trailing, 330)

            }
            .padding()


        }
        .onAppear {
            viewModel.fetchCoordinates(for: id_ruta)
        }
    }
}

