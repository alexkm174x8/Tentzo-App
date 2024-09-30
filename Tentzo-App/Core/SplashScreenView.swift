//
//  SplashView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 28/09/24.
//

import SwiftUI

struct SplashScreenView: View {
    let customGreen = Color(red: 127 / 255.0, green: 194 / 255.0, blue: 151 / 255.0)
    
    var body: some View {
        ZStack {
            customGreen
                .ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .padding(.bottom, 50)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
