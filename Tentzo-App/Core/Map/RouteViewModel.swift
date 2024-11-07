//
//  RouteViewModel.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import Foundation
import FirebaseFirestore

class RouteViewModel: ObservableObject {
    @Published var coordinates: [Coordinate] = []
    @Published var errorMessage: String? = nil

    private var db = Firestore.firestore()

    func fetchCoordinates(for id_ruta: Int) {
        db.collection("Coordenada")
            .whereField("id_ruta", isEqualTo: id_ruta)
            .order(by: "id")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error fetching coordinates: \(error.localizedDescription)"
                    }
                    print("Error fetching coordinates: \(error)")
                } else {
                    if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.coordinates = snapshot.documents.compactMap { document in
                                do {
                                    let coordinate = try document.data(as: Coordinate.self)
                                    print("Fetched coordinate: \(coordinate)")
                                    return coordinate
                                } catch {
                                    print("Error decoding coordinate: \(error)")
                                    return nil
                                }
                            }
                            if self.coordinates.isEmpty {
                                self.errorMessage = "No coordinates found for id_ruta \(id_ruta)."
                                print(self.errorMessage ?? "")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Snapshot is nil."
                            print(self.errorMessage ?? "")
                        }
                    }
                }
            }
    }
}
