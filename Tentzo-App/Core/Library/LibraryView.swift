import SwiftUI
import UIKit

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    HStack(){
                        Text("Biblioteca")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.leading, 15)
                    SearchBar()
                }
                LazyVStack(spacing: 20){
                    //ForEach(plants, id: \.self) {plant in
                        //NavigationLink(value: plant){
                            
                        //}
                    Text("Biblioteca")
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
