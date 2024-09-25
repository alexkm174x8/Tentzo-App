import SwiftUI

struct PlantDetails: View {
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image("planta")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .padding(.trailing, 325)
                    .padding(.top, 5)
            }
            
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 394, height: 550)
                        .overlay(
                            
                            VStack(alignment: .leading, spacing: 20) {

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Epipremnum aureum")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 127/255, green: 194/255, blue: 151/255))
                                    
                                    Text("Planta Potos")
                                        .font(.system(size: 30))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                .frame(alignment: .leading)
                                .padding(.leading, 20)
                                
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        VStack(alignment: .leading) {
                                            Text("Datos curiosos")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .padding(.top, 0)

                                            Text("Es una liana que puede alcanzar 20 m de alto, con tallos de hasta 4 cm de diámetro. Trepa mediante raíces aéreas que se enganchan a las ramas de los árboles. Las hojas son perennes, alternas y acorazonadas.")
                                                .font(.system(size: 18))
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                            
                                            Text("Fuente consultada")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .padding(.top, 20)
                                                .padding(.bottom, 0)

                                            Text("https://www.inaturalist.org/")
                                                .font(.system(size: 18))
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxHeight: 300)
                                
                                Spacer()
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
    PlantDetails()
}
