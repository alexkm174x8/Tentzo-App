import SwiftUI
import UIKit

struct Services: View {
    var body: some View {
        VStack {
            Divider()
            VStack(alignment: .center) {
                Text("Especie destacada")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 20)
                
                Image("plantD")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                    .frame(width: 270, height: 150)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
            .padding(.trailing)
            .padding(.top, 10)
        }
    }
}

#Preview {
    Services()
}

