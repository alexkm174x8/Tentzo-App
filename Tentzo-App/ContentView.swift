//
//  ContentView.swift
//  Tentzo-App
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        if userID == "" {
            AuthView() // si no hay sesion iniciada se abre la AuthView que es el signin
        } else {
            TabView {
                MenuView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                LibraryView()
                    .tabItem {
                        Image(systemName: "leaf.fill")
                        Text("Library")
                    }
                
                CameraView()
                    .tabItem {
                        Image(systemName: "camera")
                        Text("Camera")
                    }
                
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                
                InfoView()
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
            }
            .accentColor(.green)
        }
    }
}

#Preview {
    ContentView()
}
