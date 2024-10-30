import SwiftUI
import UIKit

struct ActivityPreview: View {
    var nombre: String
    
    var body: some View {
            HStack{
                Image("activity1")
                    .resizable()
                    .scaledToFill()
                    .overlay{
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.clear]), startPoint: .bottom, endPoint: .top))
                    }
            }
            .frame(width: 375 ,height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 5)
            .overlay{
                Text(nombre)
                    .foregroundStyle(.white)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding()
            }
        
    }
}

#Preview {
    ActivityPreview(nombre: "Actividad Sola")
}
