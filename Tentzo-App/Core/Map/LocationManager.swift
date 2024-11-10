//
//  LocationManager.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 09/11/24.
//


import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        // Request "When In Use" authorization; if you need background tracking, use `requestAlwaysAuthorization`
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        // Only start updating if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // Delegate method to update user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = latestLocation.coordinate
        }
    }

    // Delegate method to monitor authorization status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            // Optional: Start updating immediately if you want to track upon authorization
        }
    }
}
