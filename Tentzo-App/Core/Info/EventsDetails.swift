import SwiftUI

struct EventsDetails: View {
    var body: some View {
        ZStack {
                Image("pintura") // Imagen de la ruta; filename: "pintura"
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 394, height: 550)
                        .overlay(
                            
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("Arte y cultura")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 127/255, green: 194/255, blue: 151/255))
                                    
                                    Text("Cenas con arte")
                                        .font(.system(size: 30))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                .padding(.leading, 20)
                                
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Detalles")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.leading, 5)
                                        
                                        Text("Para los amantes del arte es maravilloso poder conocer las obras del artista y poder ir descubriendo poco a poco sus estilos favoritos. ¿Te imaginas tener el tiempo para disfrutar de sus obras con calma, entre amigos y con una deliciosa cena?")
                                            .font(.system(size: 18))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(nil)
                                            .padding(.leading, 5)
                                            .padding(.trailing, 5)
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Próxima fecha:")
                                                    .font(.system(size: 20))
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black)
                                                    .padding(.leading, 5)
                                                
                                                Text("24 de agosto 2024")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.black)
                                                    .padding(.leading, 5)
                                            }
                                                                                        
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Costo:")
                                                    .font(.system(size: 20))
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black)
                                                    .padding(.top, 20)
                                                    .padding(.leading, 80)

                                                Text("$450 por persona")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.black)
                                                    .padding(.leading, 80)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 200)

                                }
                                .frame(maxHeight:  440)
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
    EventsDetails()
}
