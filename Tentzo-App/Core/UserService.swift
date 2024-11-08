//
//  UserService.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 07/11/24.
//

import FirebaseAuth
import FirebaseFirestore

struct UserService {
    let db = Firestore.firestore()

    func createUserDocument(user: User, fullName: String) {
        let userRef = db.collection("Usuario").document(user.uid)
        
        userRef.setData([
            "nombre": fullName,
            "correo": user.email ?? "",
            "puntos": 0,
            "insignias": [],
            "foto_perfil": ""
        ], merge: true) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            } else {
                print("User document created/updated successfully")
            }
        }
    }
}
