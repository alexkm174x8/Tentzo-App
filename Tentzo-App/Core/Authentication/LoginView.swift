//
//  LogInView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 28/09/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss

    let customGreen = Color(red: 127 / 255, green: 194 / 255, blue: 151 / 255)

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Vive el Tentzo")
                    .font(.title2)
                    .foregroundColor(customGreen)
                    .padding(.bottom, 10)

                Text("Iniciar Sesión")
                    .font(.system(size: 45))
                    .padding(.bottom, 5)

                HStack {
                    Text("¿No tienes cuenta?")
                        .foregroundColor(.gray)

                    NavigationLink(destination: SignupView()) {
                        Text("Regístrate")
                            .foregroundColor(customGreen)
                    }
                }

                TextField("Correo", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    .onChange(of: email) { newValue, _ in
                        email = newValue.lowercased()
                    }

                HStack {
                    if showPassword {
                        TextField("Contraseña", text: $password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("Contraseña", text: $password)
                            .autocapitalization(.none)
                    }

                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                HStack {
                    Text("Dont have an account")
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Create Acooutn").foregroundColor(.green)
                    }
                }.frame(maxWidth: .infinity, alignment: .center)

            }
            .padding(.top, 40)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
