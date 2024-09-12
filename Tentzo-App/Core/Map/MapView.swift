import SwiftUI
import MapKit

//Bug: Sometimes while swiping down the map moves instead of the Route view

struct MapView: View {
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack{
            ZStack(alignment: .bottom){
                Map()
                    .ignoresSafeArea(.container, edges: .top)
                        
                VStack{
                    VStack {
                        HStack{
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .frame(width: 35, height: 5)
                                .foregroundStyle(Color(.lightGray))
                                .padding(.top , 10)
                                .opacity(0.3)
                        }
                        
                        HStack(alignment: .top){
                            Image(systemName: "map.fill")
                                .foregroundStyle(.green)
                            Text("Rutas")
                                .font(.headline)
                                .foregroundStyle(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15 )
                        RoutePreview()
                        RoutePreview()
                        RoutePreview()
                    }
                    .frame(maxHeight: .infinity, alignment: .top) // Alinear al principio
                }
                .frame(height: isExpanded ? 700 : 152, alignment: .top) // Alinear al principio
                .background(.white)
                .clipShape(RoundedCorner(radius: 25.0, corners: [.topLeft, .topRight]))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -10) // Top shadow only
                .transition(.move(edge: .bottom))
                .gesture(
                    DragGesture()
                    .onEnded { value in
                        if value.translation.height < 50 {
                            withAnimation {
                                isExpanded = true
                            }
                        } else if value.translation.height > 30 {
                            withAnimation {
                                isExpanded = false
                            }
                        }
                    }
                )
            }
            Spacer()
        }
    }
}

#Preview {
    MapView()
}
