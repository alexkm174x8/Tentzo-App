//
//  MenuView.swift
//  Tentzo
//
//  Created by Administrador on 27/08/24.
//

import SwiftUI
import UIKit

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
                        
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MenuView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("pp")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.leading, 20)
                        .background(Color.blue)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("¡Hola!, Fernanda")
                            .font(.title)
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundStyle(.white)
                            Text("Calle 27 #142B")
                                .foregroundStyle(.white)
                        }
                        Text("Mis puntos: 114")
                            .foregroundStyle(.white)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                }
                .padding()
                //aqui continuo co mis insignias
            }
            .background(Color(red: 83/255, green: 135/255, blue: 87/255))
            .clipShape(RoundedCorner(radius: 25, corners: [.bottomLeft, .bottomRight]))
            Spacer()

        }
    }
}

#Preview {
    MenuView()
}
