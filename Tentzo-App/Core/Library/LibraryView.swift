import SwiftUI
import UIKit
import Firebase


struct LibraryView: View {
    let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            SearchBar()
            ScrollView{
                LazyVStack(spacing: 20){
                    //ForEach(plants, id: \.self) {plant in
                        //NavigationLink(value: plant){
                            
                        //}
                    
                }
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(0 ... 50, id: \.self) { plant in
                        NavigationLink(value: plant){
                            PlantInfo()
                        }
                    }
                }
                .navigationDestination(for: Int.self) {_ in 
                    PlantDetails()
                        
                }
                
            }
            .navigationTitle("Biblioteca")
        }
    }
}

#Preview {
    LibraryView()
}
