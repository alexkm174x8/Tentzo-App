import SwiftUI
import MapKit

struct MapView: View {
    @State private var dragOffset = CGSize.zero
    @State private var isExpanded = false

    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                Map()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    BottomSheetView(isExpanded: $isExpanded)
                        .offset(y: isExpanded ? 50 : 40)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.height < -100 {
                                        withAnimation {
                                            isExpanded = true
                                        }
                                    } else if value.translation.height > 30 {
                                        withAnimation {
                                            isExpanded = false
                                        }
                                    }
                                    dragOffset = .zero
                                }
                        )
                        .offset(y: dragOffset.height)
                }
                
            }
        }
    }
}

struct Map: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        //let initialLocation = CLLocationCoordinate2D(latitude: 18.951006, longitude: -98.317351) // Ocoyucan
        //let regionRadius: CLLocationDistance = 1000 // Radio en metros
        //let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius) uiView.setRegion(coordinateRegion, animated: true)
    }
}

struct BottomSheetView: View {
    @Binding var isExpanded: Bool

    var body: some View {
        VStack{
            VStack{
                HStack{
                    Image(systemName: "map.fill")
                        .foregroundStyle(.green)
                    Text("Rutas")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                RoutePreview()
                RoutePreview()
                RoutePreview()
                RoutePreview()
                
                
            }
            
            // Agrega aquí la información que desees mostrar

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: isExpanded ? 820 : UIScreen.main.bounds.height / 3)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 10)
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    MapView()
}
