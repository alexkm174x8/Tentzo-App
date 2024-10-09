import SwiftUI
import FirebaseAuth

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
    @AppStorage("uid") var userID: String = ""  // Necesito el UID para cerrar sesion
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(Color(red: 83/255, green: 135/255, blue: 87/255))
                .clipShape(RoundedCorner(radius: 25, corners: [.bottomLeft, .bottomRight]))
                .ignoresSafeArea()
                .overlay {
                    HStack {
                        Image("pp")
                            .scaledToFit()
                            .frame(width: 130)
                            .clipShape(Circle())
                            .padding(.leading, 20)
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("¡Hola,")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                Text("Ale")
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
                                Text("Ubicación")
                                    .foregroundStyle(.white)
                            }
                            
                            Text("Mis puntos: 114")
                                .foregroundStyle(.white)
                            
                            Button(action: {
                                logOutUser()
                            }) {
                                Text("Cerrar Sesión")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 7)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                            }
                            .padding(.top, 7)
                        }
                        .padding(36)
                    }
                    .padding()
                }
            
        }
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
    
    func logOutUser() { // cerrar sesion
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userID = ""
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

#Preview {
    Profile()
}

