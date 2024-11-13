import SwiftUI

struct EventsDetails: View {
    var nombre: String
    var costo: String
    var detalles: String
    var fecha: String
    var imagen: String
    var tipo: String
    
    var body: some View {
        ZStack {
            AsyncImageView(url: imagen) // Imagen de la ruta; filename: "pintura"
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 420, height: 550)
                        .overlay(
                            
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text(tipo)
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 127/255, green: 194/255, blue: 151/255))
                                    
                                    Text(nombre)
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
                                        
                                        Text(detalles)
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
                                                
                                                Text(fecha)
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

                                                Text("\(costo) por persona")
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
    EventsDetails(nombre: "Cenas con arte", costo: "500", detalles: "estoy locoooooooooooooooooooooooooo", fecha: "cuando sea", imagen: "activity1", tipo: "Arte y Cultura")
}
