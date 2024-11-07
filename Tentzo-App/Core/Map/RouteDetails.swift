import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct RouteDetails: View {
    var nombre: String
    var distancia: String
    var tiempo: String
    var detalles: String
    var imagen: String
    var id_ruta: Int
    
    @State private var showMapView = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                AsyncImageView(url: imagen)
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                    
                    Text(nombre)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.trailing, 160)
                .padding(.top, 10)
            }
            
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 405, height: 500)
                        .overlay(
                            
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Distancia:")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.leading, 20)
                                        
                                        Text(distancia)
                                            .font(.largeTitle)
                                            .foregroundColor(.black)
                                            .padding(.leading, 20)
                                    }
                                    Spacer()
                                    
                                    VStack(alignment: .leading) {
                                        Text("Tiempo:")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.trailing, 23)
                                        
                                        Text(tiempo)
                                            .font(.largeTitle)
                                            .foregroundColor(.black)
                                            .padding(.trailing, 23)
                                    }
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        Text("Detalles:")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.top, 10)
                                            .padding(.leading, 5)
                                            .padding(.trailing, 5)
                                        
                                        Text(detalles)
                                            .font(.system(size: 19))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(nil)
                                            .padding(.leading, 5)
                                            .padding(.trailing, 5)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxHeight: 200)
                                
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    Button(action: {
                                        self.showMapView = true
                                    }) {
                                        Text("Iniciar ruta")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50)
                                            .background(Color(red: 127/255, green: 194/255, blue: 151/255))
                                            .cornerRadius(25)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 95)
                            }
                                .padding(.top, 30)
                        )
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $showMapView) {
                MapViewContainer(id_ruta: self.id_ruta)
            }
        }
    }
}

