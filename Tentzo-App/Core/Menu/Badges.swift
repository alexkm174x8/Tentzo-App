import SwiftUI
import UIKit

struct Badges: View {
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("Mis Insignias")
                    .bold()
                    .font(.system(size: 23))
                VStack {
                    Divider()
                        .background(Color.gray)
                        .frame(height: 2)
                }
                
            }
            .padding()
            
            HStack(spacing: 20) {
                // ForEach(image, id: \.self){ image in
                //     Image(image)
                //     .resizable()
                //     .scaleToFill()
                // }
                Circle()
                    .frame(width: 90)
                    .foregroundStyle(Color.green)
                Circle()
                    .frame(width: 90)
                    .foregroundStyle(Color.green)
                Circle()
                    .frame(width: 90)
                    .foregroundStyle(Color.green)
            }
            .padding(.bottom, 20)
        }

    }
}

#Preview {
    Badges()
}
