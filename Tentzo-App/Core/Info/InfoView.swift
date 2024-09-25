import SwiftUI
import UIKit

struct InfoView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Redes Sociales")
                        .bold()
                        .font(.system(size: 20))
                    VStack{
                        Divider()
                    }
                }
                .padding()
            HStack(spacing: 27){
                
                // Missing click function
                RoundedRectangle(cornerRadius: 30)
                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color(red: 233/255, green: 244/255, blue: 202/255))
                    .overlay {
                        Image("fb_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70)
                    }
                RoundedRectangle(cornerRadius: 30)
                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color(red: 233/255, green: 244/255, blue: 202/255))
                    .overlay {
                        Image("instagram_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70)
                    }
                RoundedRectangle(cornerRadius: 30)
                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color(red: 233/255, green: 244/255, blue: 202/255))
                    .overlay {
                        Image("x_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
            }
            .padding()
            
            Text("Mis actividades")
                .bold()
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
            NavigationLink(destination: EventsDetails()){
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
            
            NavigationLink(destination: EventsDetails()){
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
            
            NavigationLink(destination: EventsDetails()){
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
            Spacer()
        }
    }
}

#Preview {
    InfoView()
}
