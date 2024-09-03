import SwiftUI
import UIKit

struct Services: View {
    var body:some View {
        VStack {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("Mis Servicios")
                        .fontWeight(.bold)
                        .padding(.bottom, 13)
                        .font(.system(size: 24))
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(red: 233/255, green: 244/255, blue: 202/255))
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "shoeprints.fill")
                            
                            VStack {
                                Text("1,236")
                                    .bold()
                                Text("pasos")
                                    .foregroundColor(Color.gray)
                            }
                            .frame(width: 113)
                        }
                        .padding()
                    }
                }
                .padding()
                Rectangle()
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .frame(height: 120)
            .padding(.bottom)
            .padding(.trailing)
            .padding(.top, 10)
            
            HStack(spacing: 18){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 233/255, green: 244/255, blue: 202/255))
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "shoeprints.fill")
                        
                        VStack {
                            Text("1,236")
                                .bold()
                            Text("pasos")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding()
                }
                .frame(width: 170, height: 60)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 233/255, green: 244/255, blue: 202/255))
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "shoeprints.fill")
                        
                        VStack {
                            Text("1,236")
                                .bold()
                            Text("pasos")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding()
                }
                .frame(width: 170, height: 60)
            }
        }
    }
}

#Preview {
    Services()
}
