import SwiftUI
import UIKit

struct PlantInfo: View {
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                .foregroundStyle(Color(red: 127/255, green: 194/255, blue: 151/255))
                .overlay{
                    Image(systemName:"plant")
                }
            
            Text("Plant")
        }
    }
}

#Preview {
    PlantInfo()
}
