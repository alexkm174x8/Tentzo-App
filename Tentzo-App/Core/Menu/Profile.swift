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
            Rectangle()
                .foregroundStyle(Color(red: 83/255, green: 135/255, blue: 87/255))
                .clipShape(RoundedCorner(radius: 25, corners: [.bottomLeft, .bottomRight]))
                .ignoresSafeArea()
                .overlay {
                    HStack{
                        Image("pp")
                            .scaledToFit()
                            .frame(width: 130)
                            .clipShape(Circle())
                            .padding(.leading, 20)
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
                        .padding(30)
                    }
                    .padding()
                
            }
            
        }
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    Profile()
}
