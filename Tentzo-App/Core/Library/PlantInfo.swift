import SwiftUI
import UIKit

struct PlantInfo: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(red: 127/255, green: 194/255, blue: 151/255))
                .overlay {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                }

            Text("Plant")
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    PlantInfo()
}
