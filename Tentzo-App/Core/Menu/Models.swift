//
//  Models.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Coordinate: Identifiable, Codable {
    @DocumentID var id: String?
    var latitud: Double
    var longitud: Double
    var id_ruta: Int
}

struct Route: Identifiable, Codable {
    @DocumentID var id: String?
    var id_ruta: Int
    var name: String
}
