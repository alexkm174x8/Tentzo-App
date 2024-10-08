//
//  Tentzo_AppApp.swift
//  Tentzo-App
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Tentzo_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
    func loadAppData() {
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: 2)

            DispatchQueue.main.async {
                isLoading = false
            }
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
