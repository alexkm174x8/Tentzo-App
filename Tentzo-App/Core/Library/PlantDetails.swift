import SwiftUI
import UIKit

struct PlantDetails: View {
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundStyle(.white)
            .background{
                Circle()
                    .fill(.black)
                    .frame(width: 32, height: 32)
            }
            .padding(32)
    }
}

#Preview {
    PlantDetails()
}
