import SwiftUI
import UIKit

struct SearchBar: View {
    var body: some View {
        HStack(){
            Image(systemName: "magnifyingglass")
            
            VStack(alignment: .trailing, spacing: 2){
                TextField("Busca una planta", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding()
    }
}

#Preview {
    SearchBar()
}
