import SwiftUI
import UIKit

struct TabBar: View {
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
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            InfoView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Info")
                }
        }
    }
}

#Preview {
    TabBar()
}
