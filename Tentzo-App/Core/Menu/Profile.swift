import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
    @AppStorage("uid") var userID: String = ""
    @State private var firstName: String = "Tú" // por si no se jala bien la info, que diga algo generico

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
                                Text(firstName)
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
        .onAppear {
            fetchUserFirstName()
        }
    }
    
    func fetchUserFirstName() {
        let db = Firestore.firestore()
        guard !userID.isEmpty else { return }
        
        let userRef = db.collection("Usuario").document(userID)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let fullName = document.data()?["nombre"] as? String {
                    // que solo se muestre el primer nombre
                    firstName = fullName.components(separatedBy: " ").first ?? "User"
                }
            } else if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    func logOutUser() { // Log out
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

