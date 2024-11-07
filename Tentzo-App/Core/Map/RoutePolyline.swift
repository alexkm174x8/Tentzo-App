//
//  RoutePolyline.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//

import SwiftUI
import MapKit

struct RoutePolyline: UIViewRepresentable {
    var coordinates: [Coordinate]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator // Set the delegate here
        updateOverlay(mapView: mapView)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateOverlay(mapView: uiView)
    }
    
    private func updateOverlay(mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays) // Clear existing overlays before adding new ones
        
        let polylineCoordinates = coordinates.map { CLLocationCoordinate2D(latitude: $0.latitud, longitude: $0.longitud) }
        let polyline = MKPolyline(coordinates: polylineCoordinates, count: polylineCoordinates.count)
        mapView.addOverlay(polyline)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
