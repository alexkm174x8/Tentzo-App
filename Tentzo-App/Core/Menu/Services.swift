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
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(red: 233/255, green: 244/255, blue: 202/255))
                        
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
                }
                .padding()
                Rectangle()
                    .cornerRadius(20)
            }
            .frame(height: 120)
            .padding(.bottom)
            .padding(.trailing)
            .padding(.top, 10)
            
            HStack(spacing: 18){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 233/255, green: 244/255, blue: 202/255))
                    
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
