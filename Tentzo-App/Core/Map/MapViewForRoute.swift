//
//  MapViewForRoute.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import SwiftUI
import MapKit

struct MapViewForRoute: UIViewRepresentable {
    var coordinates: [Coordinate]
    @ObservedObject var locationManager = LocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        let locations = coordinates.map {
            CLLocationCoordinate2D(latitude: $0.latitud, longitude: $0.longitud)
        }
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        
        if let userLocation = locationManager.userLocation {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        } else if let firstLocation = locations.first {
            let region = MKCoordinateRegion(center: firstLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
