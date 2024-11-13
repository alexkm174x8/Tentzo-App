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
    var finishPoint: CLLocationCoordinate2D
    var mapType: MKMapType = .hybrid
    @ObservedObject var locationManager = LocationManager()
    var isFirstPersonViewEnabled: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = mapType
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        // Create and add the polyline overlay for the route coordinates
        let locations = coordinates.map { CLLocationCoordinate2D(latitude: $0.latitud, longitude: $0.longitud) }
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        
        if isFirstPersonViewEnabled, let userLocation = locationManager.userLocation {
            // First-person view: Keep the camera moving with the user’s location
            context.coordinator.updateCameraPosition(mapView, userLocation: userLocation, finishPoint: finishPoint)
            context.coordinator.updateArrowAnnotation(mapView, location: userLocation)
        } else {
            // Regular view: Display the entire route on the map
            if !locations.isEmpty {
                let routeRegion = calculateRegion(for: locations)
                mapView.setRegion(routeRegion, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func calculateRegion(for locations: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var minLat = locations.first!.latitude
        var maxLat = locations.first!.latitude
        var minLong = locations.first!.longitude
        var maxLong = locations.first!.longitude
        for location in locations {
            minLat = min(minLat, location.latitude)
            maxLat = max(maxLat, location.latitude)
            minLong = min(minLong, location.longitude)
            maxLong = max(maxLong, location.longitude)
        }
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLong + maxLong) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.3,
            longitudeDelta: (maxLong - minLong) * 1.3
        )
        return MKCoordinateRegion(center: center, span: span)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var arrowAnnotation = MKPointAnnotation()
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func updateCameraPosition(_ mapView: MKMapView, userLocation: CLLocationCoordinate2D, finishPoint: CLLocationCoordinate2D) {
            let heading = calculateHeading(from: userLocation, to: finishPoint)
            let camera = MKMapCamera(
                lookingAtCenter: userLocation,
                fromDistance: 300, // Adjust the distance for first-person perspective
                pitch: 70, // High pitch to simulate first-person view
                heading: heading
            )
            mapView.setCamera(camera, animated: true)
        }
        
        func updateArrowAnnotation(_ mapView: MKMapView, location: CLLocationCoordinate2D) {
            arrowAnnotation.coordinate = location
            if !mapView.annotations.contains(where: { $0 === arrowAnnotation }) {
                mapView.addAnnotation(arrowAnnotation)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation === arrowAnnotation {
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "arrow") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "arrow")
                
                annotationView.image = UIImage(systemName: "arrowshape.up.circle.fill")
                
                annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(arrowAnnotationRotation(for: mapView.camera.heading)))
                
                return annotationView
            }
            return nil
        }

        private func arrowAnnotationRotation(for heading: CLLocationDirection) -> Double {
            return heading * .pi / 180
        }
        
        private func calculateHeading(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> CLLocationDirection {
            let deltaLong = end.longitude - start.longitude
            let y = sin(deltaLong) * cos(end.latitude)
            let x = cos(start.latitude) * sin(end.latitude) - sin(start.latitude) * cos(end.latitude) * cos(deltaLong)
            let heading = atan2(y, x)
            return heading * 180 / .pi
        }
    }
}
