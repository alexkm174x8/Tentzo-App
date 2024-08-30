import SwiftUI
import UIKit

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct Profile: View {
    var body: some View {
        VStack {
            HStack {
                Image("pp")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.leading, 20)
                    .background(Color.blue)
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("¡Hola,")
                            .font(.title)
                            .foregroundStyle(.white)
                        Text("Yo")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("!")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.white)
                        Text("Calle 27 #142B")
                            .foregroundStyle(.white)
                    }
                    Text("Mis puntos: 114")
                        .foregroundStyle(.white)
                }
                .padding(10)
            }
            .padding()
            .background(Color(red: 83/255, green: 135/255, blue: 87/255))
            .clipShape(RoundedCorner(radius: 25, corners: [.bottomLeft, .bottomRight]))
        }

    }
}

#Preview {
    Profile()
}
