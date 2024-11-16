//
//  Planta.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 15/11/24.
//


import Foundation
import FirebaseFirestoreSwift

// Define the Planta model
struct Planta: Identifiable, Decodable {
    @DocumentID var id: String?
    var imagen: String
    var nomCientifico: String
}
