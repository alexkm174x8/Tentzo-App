import SwiftUI

struct RouteDetails: View {
        var body: some View {
            ZStack {

                ZStack(alignment: .top) {
                    Image("ruta") // Imagen de la ruta; filename: "ruta"
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 25))

                        Text("Ruta Tentzo")
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
                            .frame(width: 394, height: 500)
                            .overlay(
                                
                                VStack(alignment: .leading, spacing: 20) {

                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Distancia:")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .padding(.leading, 20)
                                            
                                            Text("3 km")
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
                                            
                                            Text("60 min")
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
                                            
                                            Text("La Ruta Tentzo tiene una longitud de 8 kilómetros. A lo largo del recorrido, podrás disfrutar de una gran variedad de ecosistemas, desde bosques de pinos hasta áreas abiertas con praderas floridas.")
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
            }
        }
    }
#Preview {
    RouteDetails()
}
