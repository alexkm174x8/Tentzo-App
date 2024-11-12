//
//  MapViewForRoute.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import SwiftUI
import MapKit

struct MapViewWithBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    var coordinates: [Coordinate]
    var finishPoint: CLLocationCoordinate2D
    var completionThreshold: Double = 10.0
    
    @State private var mapType: MKMapType = .standard
    
    var body: some View {
        ZStack {
            MapViewForRoute(
                coordinates: coordinates,
                finishPoint: finishPoint,
                completionThreshold: completionThreshold,
                mapType: mapType
            )
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                            .padding()
                    }
                    Spacer()
                    
                    Picker("Map Type", selection: $mapType) {
                        Text("Standard").tag(MKMapType.standard)
                        Text("Satellite").tag(MKMapType.satellite)
                        Text("Hybrid").tag(MKMapType.hybrid)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.trailing)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapViewForRoute: UIViewRepresentable {
    var coordinates: [Coordinate]
    var finishPoint: CLLocationCoordinate2D
    var completionThreshold: Double = 10.0
    var mapType: MKMapType
    @ObservedObject var locationManager = LocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.mapType = mapType
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.mapType = mapType
        
        let locations = coordinates.map {
            CLLocationCoordinate2D(latitude: $0.latitud, longitude: $0.longitud)
        }
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        
        if !locations.isEmpty {
            let region = calculateRegion(for: locations)
            mapView.setRegion(region, animated: true)
        }
        
        if let userLocation = locationManager.userLocation {
            checkIfUserReachedFinish(userLocation: userLocation)
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
    
    func checkIfUserReachedFinish(userLocation: CLLocationCoordinate2D) {
        let userLocationPoint = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let finishLocationPoint = CLLocation(latitude: finishPoint.latitude, longitude: finishPoint.longitude)
        let distanceToFinish = userLocationPoint.distance(from: finishLocationPoint)
        
        if distanceToFinish <= completionThreshold {
            DispatchQueue.main.async {
                showCompletionAlert()
            }
        }
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "¡Felicidades!", message: "Has completado la ruta.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
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
