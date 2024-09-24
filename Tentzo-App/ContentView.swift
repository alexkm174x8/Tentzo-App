//
//  ContentView.swift
//  Tentzo-App
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        TabView{
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
                    Image(systemName: "person")
                    Text("Info")
                }
        }
    }
}

#Preview {
    ContentView()
}
