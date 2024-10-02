import SwiftUI
import UIKit

struct RoutePreview: View {
    var body: some View {
        Button(action: {}){
            HStack{
                Rectangle() // Here goes the image
            }
            .frame(width: 375 ,height: 105)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 5)
            .overlay{
                Text("Ruta 1")
                    .foregroundStyle(.white)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding()
            }
        }
        
    }
}

#Preview {
    RoutePreview()
}
