//
//  Tentzo_AppApp.swift
//  Tentzo-App
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI

@main
struct Tetzo_AppApp: App {
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
