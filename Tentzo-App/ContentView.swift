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
                        Text("Inicio")
                    }
                LibraryView()
                    .tabItem {
                        Image(systemName: "leaf.fill")
                        Text("Biblioteca")
                    }
                
                CameraView()
                    .tabItem {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Identificar")
                    }
                
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Rutas")
                    }
                
                InfoView()
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
            }
            .accentColor(Color(red: 83/255, green: 135/255, blue: 87/255))
        }
    }
}

#Preview {
    ContentView()
}
