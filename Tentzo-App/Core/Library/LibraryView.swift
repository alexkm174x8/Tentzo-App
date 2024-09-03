import SwiftUI
import UIKit

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Text("Biblioteca")
                        .font(.title)
                        .bold()
                }
                SearchBar()
                
            }
            
        }
    }
}

#Preview {
    LibraryView()
}
