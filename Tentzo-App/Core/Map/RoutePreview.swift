import SwiftUI
import UIKit

struct RoutePreview: View {
    var body: some View {
        Button(action: {}){
            HStack{
                        Rectangle()
                    }
                    .frame(width: 375 ,height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
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
