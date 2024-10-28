import SwiftUI

struct EmergencyButton: View {
    var body: some View {
        HStack {
            Button("Emergencias") {
                if let url = URL(string: "tel://911"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .frame(width: 300, height: 50)
            .foregroundColor(.white)
            .font(.title)
            .background(Color(red: 83/255, green: 135/255, blue: 87/255))
            .cornerRadius(30)
            .shadow(color: .gray, radius: 10, x: 0, y: 5)
        }
        .padding(.top, 50)
        .padding(.bottom, 50)
    }
}

#Preview {
    EmergencyButton()
}
