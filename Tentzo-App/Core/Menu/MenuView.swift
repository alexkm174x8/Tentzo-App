import SwiftUI
import FirebaseFirestore

struct Insignia: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageUrl: String
}

struct MenuView: View {
    @State private var insignias: [Insignia] = []
    @State private var selectedInsignia: Insignia?
    
    var body: some View {
        NavigationStack {
            VStack {
                Profile()
                insigniaSection()
                Services()
                EmergencyButton()
            }
            .onAppear {
                fetchInsignias()
            }
            .overlay(
                Group {
                    if let insignia = selectedInsignia {
                        FullScreenInsigniaOverlay(insignia: insignia) {
                            withAnimation {
                                selectedInsignia = nil
                            }
                        }
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    private func insigniaSection() -> some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("Mis Insignias")
                    .bold()
                    .font(.system(size: 25))
                VStack {
                    Divider()
                        .background(Color.gray)
                        .frame(height: 2)
                }
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(insignias) { insignia in
                        Circle()
                            .frame(width: 90)
                            .foregroundStyle(Color.white)
                            .overlay {
                                AsyncImage(url: URL(string: insignia.imageUrl)) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedInsignia = insignia
                                }
                            }
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private func fetchInsignias() {
        let db = Firestore.firestore()
        
        db.collection("Insignia").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching insignias: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No badges found")
                return
            }
            
            insignias = documents.compactMap { document in
                let data = document.data()
                return Insignia(
                    id: document.documentID,
                    name: data["nombre"] as? String ?? "Sin Nombre",
                    description: data["descripcion"] as? String ?? "Sin Descripción",
                    imageUrl: data["imagen_b"] as? String ?? ""
                )
            }
        }
    }
}

struct FullScreenInsigniaOverlay: View {
    var insignia: Insignia
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack {
                Text(insignia.name)
                    .font(.headline)
                    .padding(.top)
                
                AsyncImage(url: URL(string: insignia.imageUrl)) { image in
                    image.resizable()
                        .scaledToFit()
                        .padding(.top)
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
                
                Text(insignia.description)
                    .padding()
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 250, height: 300)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .transition(.scale)
    }
}

// Preview
#Preview {
    MenuView()
}

