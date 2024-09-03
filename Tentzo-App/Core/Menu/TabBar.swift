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
        }
    }
}

#Preview {
    TabBar()
}
