import SwiftUI
import MapKit

struct RouteMapViewRepresentable: UIViewRepresentable {
    var routeCoordinates: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)

        // Add route polyline
        if !routeCoordinates.isEmpty {
            print("Route Coordinates: \(routeCoordinates)") // Add this line
            let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
            mapView.addOverlay(polyline)

            // Adjust the map region to fit the route
            let region = MKCoordinateRegion(polyline.boundingMapRect)
            mapView.setRegion(region, animated: true)
        } else {
            print("No route coordinates to display.")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteMapViewRepresentable

        init(_ parent: RouteMapViewRepresentable) {
            self.parent = parent
        }

        // Renderer for the polyline overlay
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            print("Renderer called for overlay")
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .magenta
                renderer.lineWidth = 20
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

