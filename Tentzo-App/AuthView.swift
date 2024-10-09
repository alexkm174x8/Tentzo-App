//
//  AuthView.swift
//  FirebaseAuthPrueba
//
//  Created by Miranda Colorado Arróniz on 08/10/24.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "signup" // Lo que se muestra primero, login o signup
        
    var body: some View {
        
        if(currentViewShowing == "login") {
            LoginView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.light)
        } else {
            SignupView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }
  
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
