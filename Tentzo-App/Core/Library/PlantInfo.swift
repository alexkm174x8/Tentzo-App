import SwiftUI
import FirebaseFirestore
import UIKit

struct PlantInfo: View {
    @State private var retrievedImage: UIImage?

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(red: 127/255, green: 194/255, blue: 151/255))
                .overlay {
                    if let image = retrievedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                    }
                }

            Text("Actividad")
                .foregroundStyle(Color.black)
        }
        .onAppear {
            retrieveImageUrl()
        }
    }

    func retrieveImageUrl() {
        let db = Firestore.firestore()
        
        db.collection("Actividad").document("1").getDocument { document, error in
            guard let document = document, document.exists,
                  let imageUrl = document.data()?["imagen"] as? String else {
                return
            }

            retrievePhoto(from: imageUrl)
        }
    }

    func retrievePhoto(from imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                retrievedImage = image
            }
        }.resume()
    }
}

#Preview {
    PlantInfo()
}
