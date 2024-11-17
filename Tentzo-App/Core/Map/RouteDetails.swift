import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct RouteDetails: View {
    var nombre: String
    var distancia: String
    var tiempo: String
    var detalles: String
    var id_ruta: Int
    
    @State private var showMapView = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                MapViewPreview(id_ruta: id_ruta)
            }
            
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 420, height: 500)
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
                                
                                Text(nombre)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(.leading)
                                    .padding(.leading, 5)
                                
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        Text("Detalles:")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
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
                                
                                HStack {
                                    Spacer()
                                    
                                    Button(action: {
                                        self.showMapView = true
                                    }) {
                                        Text("Abrir ruta")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50)
                                            .background(Color(red: 83/255, green: 135/255, blue: 87/255))
                                            .cornerRadius(25)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 75)
                            }
                            .padding(.top, 30)
                        )
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $showMapView) {
                MapViewContainer(
                    nombre: self.nombre,
                    distancia: self.distancia,
                    tiempo: self.tiempo,
                    detalles: self.detalles,
                    id_ruta: self.id_ruta
                )
            }
        }
    }
}

