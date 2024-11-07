//
//  RouteViewModel.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestore
import Combine
import CoreLocation

class RouteViewModel: ObservableObject {
    @Published var coordinates: [Coordinate] = []
    
    private var db = Firestore.firestore()
    
    func fetchCoordinates(for routeId: Int) {
        db.collection("Coordenada")
            .whereField("id_ruta", isEqualTo: routeId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching coordinates: \(error)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    self.coordinates = documents.compactMap { document in
                        try? document.data(as: Coordinate.self)
                    }
                }
            }
    }
}
