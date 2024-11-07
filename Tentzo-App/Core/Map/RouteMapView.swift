//
//  RouteMapView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//


import SwiftUI
import MapKit

struct RouteMapView: View {
    var coordinates: [Coordinate]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: coordinates) { coordinate in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitud, longitude: coordinate.longitud))
        }
        .onAppear {
            if let firstCoordinate = coordinates.first {
                let firstLocation = CLLocationCoordinate2D(latitude: firstCoordinate.latitud, longitude: firstCoordinate.longitud)
                region = MKCoordinateRegion(center: firstLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
        .overlay(
            RoutePolyline(coordinates: coordinates),
            alignment: .center
        )
    }
}
