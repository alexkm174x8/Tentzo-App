//
//  StartView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 08/10/24.
//

import SwiftUI
import FirebaseAuth

struct StartView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.signedIn {
            MenuView()
        } else {
            SignupView()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    @StateObject static var authService = AuthService()

    static var previews: some View {
        if authService.signedIn {
            MenuView()
        } else {
            SignupView()
        }
    }
}
