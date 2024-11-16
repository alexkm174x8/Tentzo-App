//
//  PlantaViewModel.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 15/11/24.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

// Create the ViewModel to fetch data from Firestore
class PlantaViewModel: ObservableObject {
    @Published var planta: Planta?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore()
    
    init() {
        fetchRandomPlanta()
        
        // Listen to app becoming active to fetch a new random plant
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func appDidBecomeActive() {
        fetchRandomPlanta()
    }
    
    func fetchRandomPlanta() {
        isLoading = true
        errorMessage = nil
        planta = nil
        
        db.collection("Planta").getDocuments { [weak self] (snapshot, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Error fetching Planta: \(error.localizedDescription)"
                    print("Error fetching Planta: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    self?.errorMessage = "No Planta documents found"
                    print("No Planta documents found")
                    return
                }
                
                // Select a random document
                let randomIndex = Int.random(in: 0..<documents.count)
                let randomDocument = documents[randomIndex]
                
                do {
                    // Decode the document into a Planta object
                    let planta = try randomDocument.data(as: Planta.self)
                    self?.planta = planta
                } catch {
                    self?.errorMessage = "Error decoding Planta: \(error.localizedDescription)"
                    print("Error decoding Planta: \(error)")
                }
            }
        }
    }
}
