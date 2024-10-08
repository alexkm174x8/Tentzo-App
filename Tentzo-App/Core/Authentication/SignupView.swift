//
//  SignUpView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 28/09/24.
//

import SwiftUI

struct SignupView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject var authService: AuthService

    let customGreen = Color(red: 127 / 255, green: 194 / 255, blue: 151 / 255)
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Vive el Tentzo")
                .font(.title2)
                .foregroundColor(customGreen)
                .padding(.bottom, 10)
            
            Text("Registrarse")
                .font(.system(size: 45))
                .padding(.bottom, 5)
            
            TextField("Nombre Completo", text: $fullName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 20)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
            
            SecureField("Contraseña", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .textContentType(.oneTimeCode)

            
            SecureField("Repetir Contraseña", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .textContentType(.oneTimeCode)

        
             Button("Registrarse") {
                 authService.regularCreateAccount(email: email, password: password)
             }
             .fontWeight(.bold)
             .foregroundColor(.white)
             .frame(maxWidth: .infinity)
             .padding()
             .background(customGreen)
             .cornerRadius(8)
             .padding(.horizontal, 25)
             .font(.system(size: 20))
             .padding(.top, 20)
            
            HStack {
                Text("Ya tienes una cuenta? ")
                NavigationLink(destination: LoginView()) {
                    Text("Login").foregroundColor(.green)
                }
            }
            
        }
        .padding(.top, 40)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
