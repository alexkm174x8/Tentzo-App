//
//  PlantPopupView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 15/11/24.
//


import SwiftUI

struct PlantPopupView: View {
    var body: some View {
        HStack(spacing: 10) {
            // Plant image
            Image("plant_image") // Replace with your image name or AsyncImage for a URL
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80) // Adjust size as needed
                .cornerRadius(10)
            
            // Text information
            VStack(alignment: .leading, spacing: 5) {
                Text("Melampodium perfoliatum")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("perfoliate blackfoot")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Text("Exactitud: 99.0%")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(red: 127/255, green: 194/255, blue: 151/255))
        .cornerRadius(15)
    }
}

struct PlantPopupView_Previews: PreviewProvider {
    static var previews: some View {
        PlantPopupView()
            .previewLayout(.sizeThatFits)
    }
}
