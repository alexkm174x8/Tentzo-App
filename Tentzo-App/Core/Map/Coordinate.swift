//
//  Coordinate.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import Foundation
import FirebaseFirestore

struct Coordinate: Identifiable, Codable {
    @DocumentID var documentID: String?
    var id: Int
    var latitud: Double
    var longitud: Double
    var id_ruta: Int

    enum CodingKeys: String, CodingKey {
        case id
        case latitud
        case longitud
        case id_ruta
    }
}
