//
//  ImageView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 14/11/24.
//

import SwiftUI

struct ImageView: View {
    let imageData: Data
    
    var body: some View {
        Group {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all, edges: .all)
            } else {
                Text("Error displaying image")
                    .foregroundColor(.white)
            }
        }
    }
}
