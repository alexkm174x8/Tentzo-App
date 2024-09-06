import SwiftUI
import UIKit

struct LibraryView: View {
    let columns = [GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
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
            .cornerRadius(10)
            ScrollView{
                
                LazyVStack(spacing: 20){
                    //ForEach(plants, id: \.self) {plant in
                        //NavigationLink(value: plant){
                            
                        //}
                    
                }
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(0 ... 50, id: \.self) { value in
                        PlantInfo()
                    }
                }
                
            }
        }
    }
}

#Preview {
    LibraryView()
}
