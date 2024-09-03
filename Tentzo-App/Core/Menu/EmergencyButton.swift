import SwiftUI
import UIKit

struct EmergencyButton: View {
    var body: some View {
        HStack{
            Button("Emergencias") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                    .frame(width: 300, height: 50)
                    .foregroundStyle(Color.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .background(Color(red: 83/255, green: 135/255, blue: 87/255))
                    .cornerRadius(30)
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
        }
        .padding(.top, 50)
        .padding(.bottom, 50)
    }
}

#Preview {
    EmergencyButton()
}
