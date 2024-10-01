import SwiftUI
import UIKit

struct Badges: View {
    @State private var selectedBadge: Int?

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center, spacing: 10) {
                    Text("Mis Insignias")
                        .bold()
                        .font(.system(size: 23))
                    VStack {
                        Divider()
                            .background(Color.gray)
                            .frame(height: 2)
                    }
                }
                .padding()
                
                HStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .frame(width: 90)
                            .foregroundStyle(Color.green)
                            .overlay {
                                Image("badge\(index + 1)")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedBadge = (selectedBadge == index) ? nil : index
                                }
                            }
                    }
                }
                .padding(.bottom, 20)
            }

            if let index = selectedBadge {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            selectedBadge = nil
                        }
                    }

                VStack {
                    Text("Insignia \(index + 1)")
                        .padding()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Image("badge\(index + 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    Text("Descripcion")
                        .padding()
                }
                .padding()
                .transition(.scale)
                .zIndex(1)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
    }
}

#Preview {
    Badges()
}
