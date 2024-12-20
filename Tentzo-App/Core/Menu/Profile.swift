import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

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
    @State private var firstName: String = "Tú"
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var points: Int = 0
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(Color(red: 83/255, green: 135/255, blue: 87/255))
                .clipShape(RoundedCorner(radius: 25, corners: [.bottomLeft, .bottomRight]))
                .ignoresSafeArea()
                .overlay {
                    HStack(spacing: 20) {
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                                    .padding(.leading, 20)
                            } else {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("¡ Hola,")
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
                            
                            Text("Mis puntos: \(points)")
                                .foregroundStyle(.white)
                        }
                        .padding(10)
                    }
                }
            
        }
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
        .onAppear {
            fetchUserFirstName()
            fetchUserPoints()
            loadProfileImage()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $profileImage, onImagePicked: { image in
                if let image = image {
                    uploadProfileImage(image)
                }
            })
        }
    }
    
    func fetchUserFirstName() {
        let db = Firestore.firestore()
        guard !userID.isEmpty else { return }
        
        let userRef = db.collection("Usuario").document(userID)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let fullName = document.data()?["nombre"] as? String {
                    firstName = fullName.components(separatedBy: " ").first ?? "User"
                }
            } else if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserPoints() {
        let db = Firestore.firestore()
        guard !userID.isEmpty else { return }
        
        let userRef = db.collection("Usuario").document(userID)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let userPoints = document.data()?["puntos"] as? Int {
                    points = userPoints
                }
            } else if let error = error {
                print("Error fetching user points: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference().child("Fotos_perfil/\(userID).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                if let url = url {
                    saveProfileImageURL(url.absoluteString)
                }
            }
        }
    }
    
    func saveProfileImageURL(_ url: String) {
        let db = Firestore.firestore()
        guard !userID.isEmpty else { return }
        
        let userRef = db.collection("Usuario").document(userID)
        userRef.updateData(["foto_perfil": url]) { error in
            if let error = error {
                print("Error saving profile image URL: \(error.localizedDescription)")
            } else {
                print("Profile image URL saved successfully")
            }
        }
    }
    
    func loadProfileImage() {
        let db = Firestore.firestore()
        guard !userID.isEmpty else { return }
        
        let userRef = db.collection("Usuario").document(userID)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let urlString = document.data()?["foto_perfil"] as? String,
                   let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                profileImage = image
                            }
                        }
                    }.resume()
                }
            }
        }
    }
}

#Preview {
    Profile()
}

