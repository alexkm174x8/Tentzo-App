//
//  RouteView 2.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 06/11/24.
//


import SwiftUI
import Firebase
import MapKit

struct RouteView: View {
    let routeID: Int
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @Environment(\.presentationMode) var presentationMode // To dismiss the view if needed

    var body: some View {
        ZStack(alignment: .topLeading) {
            MapViewRepresentable(coordinates: coordinates)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    fetchCoordinates()
                }
            
            // Back button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
    
    func fetchCoordinates() {
        let db = Firestore.firestore()
        db.collection("Coordenada").whereField("id_ruta", isEqualTo: routeID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching coordinates: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                // Sort documents based on 'id' to maintain the route order
                let sortedDocuments = documents.sorted { (doc1, doc2) -> Bool in
                    let id1 = doc1.data()["id"] as? Int ?? 0
                    let id2 = doc2.data()["id"] as? Int ?? 0
                    return id1 < id2
                }
                
                self.coordinates = sortedDocuments.compactMap { document in
                    let data = document.data()
                    if let lat = data["latitud"] as? Double,
                       let lon = data["longitud"] as? Double {
                        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    } else {
                        return nil
                    }
                }
            }
    }
}
