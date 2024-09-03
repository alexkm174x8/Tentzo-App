import SwiftUI
import UIKit

struct SearchBar: View {
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
            
            VStack(alignment: .leading, spacing: 2){
                Text("Busca una planta")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
        }
    }
}

#Preview {
    SearchBar()
}
