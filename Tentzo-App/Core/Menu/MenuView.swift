import SwiftUI
import UIKit

struct MenuView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Profile()
                Badges()
                Services()
                EmergencyButton()
            }
        }
    }
}

#Preview {
    MenuView()
}
