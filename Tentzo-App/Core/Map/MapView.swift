import SwiftUI
import MapKit

//For map lock
struct MapViewRepresentable: UIViewRepresentable {
    var isInteractionDisabled: Bool

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.isScrollEnabled = !isInteractionDisabled
        uiView.isZoomEnabled = !isInteractionDisabled
        uiView.isRotateEnabled = !isInteractionDisabled
        uiView.isPitchEnabled = !isInteractionDisabled
    }
}


struct MapView: View {
    @State private var isExpanded: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack(alignment: .bottom) {
                    MapViewRepresentable(isInteractionDisabled: isExpanded)
                        .ignoresSafeArea(.container, edges: .top)
                    
                    VStack {
                        VStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .frame(width: 35, height: 5)
                                    .foregroundStyle(Color(.lightGray))
                                    .padding(.top, 10)
                                    .opacity(0.3)
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "map.fill")
                                    .foregroundStyle(.green)
                                Text("Rutas")
                                    .font(.headline)
                                    .foregroundStyle(.green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                            NavigationLink(destination: RouteDetails()){
                                HStack{
                                    Rectangle() // Here goes the image
                                }
                                .frame(width: 375 ,height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(radius: 5)
                                .overlay{
                                    Text("Ruta 1")
                                        .foregroundStyle(.white)
                                        .bold()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                        .padding()
                                }
                            }
                            NavigationLink(destination: RouteDetails()){
                                HStack{
                                    Rectangle() // Here goes the image
                                }
                                .frame(width: 375 ,height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(radius: 5)
                                .overlay{
                                    Text("Ruta 1")
                                        .foregroundStyle(.white)
                                        .bold()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                        .padding()
                                }
                            }
                            NavigationLink(destination: RouteDetails()){
                                HStack{
                                    Rectangle() // Here goes the image
                                }
                                .frame(width: 375 ,height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(radius: 5)
                                .overlay{
                                    Text("Ruta 1")
                                        .foregroundStyle(.white)
                                        .bold()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                        .padding()
                                }
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .frame(height: isExpanded ? 700 : 152, alignment: .top)
                    .background(.white)
                    .clipShape(RoundedCorner(radius: 25.0, corners: [.topLeft, .topRight]))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -10)
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
}

#Preview {
    MapView()
}
