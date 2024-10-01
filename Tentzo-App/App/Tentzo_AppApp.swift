//
//  Tentzo_AppApp.swift
//  Tentzo-App
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI

@main
struct Tentzo_AppApp: App {
    var body: some Scene {
        WindowGroup{
            ContentView()
        }
    }
}

/*
import SwiftUI
import FirebaseCore

@main
struct Tetzo_AppApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    @State private var isLoading = true
    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashScreenView()
                    .onAppear {
                        loadAppData()
                    }
            } else {
                if isLoggedIn {
                    ContentView()
                } else {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
            }
        }
    }

    // Simulación de carga de datos de la app
    func loadAppData() {
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: 2)

            DispatchQueue.main.async {
                isLoading = false
            }
        }
    }
}
*/
