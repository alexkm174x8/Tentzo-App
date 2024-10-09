//
//  Tentzo_AppApp.swift
//  Tentzo-App
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI
import FirebaseCore

@main
struct Tentzo_AppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


