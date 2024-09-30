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
    @State private var showPassword: Bool = false // Controla si la contraseña es visible
    @Binding var isLoggedIn: Bool

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

                // Campo de correo electrónico forzado a minúsculas
                TextField("Correo", text: $email)
                    .autocapitalization(.none) // Desactiva la capitalización automática
                    .keyboardType(.emailAddress) // Tipo de teclado de correo electrónico
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    // Nueva implementación de onChange para iOS 17
                    .onChange(of: email) { newValue, _ in
                        email = newValue.lowercased() // Convierte el correo a minúsculas
                    }

                // Campo de contraseña con opción de ver/ocultar
                HStack {
                    if showPassword {
                        TextField("Contraseña", text: $password)
                            .autocapitalization(.none) // Desactiva la capitalización automática
                    } else {
                        SecureField("Contraseña", text: $password)
                            .autocapitalization(.none) // Desactiva la capitalización automática
                    }

                    // Botón para mostrar/ocultar contraseña
                    Button(action: {
                        showPassword.toggle() // Alterna entre mostrar y ocultar la contraseña
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill") // Icono de ojo
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)

                Button(action: {
                }) {
                    Text("¿Olvidaste tu contraseña?")
                        .foregroundColor(.gray)
                }
                .padding(.top, 5)

                Button(action: {
                    // Verifica las credenciales
                    if email == "prueba@gmail.com" && password == "123" {
                        isLoggedIn = true
                    } else {
                        print("Credenciales incorrectas")
                    }
                }) {
                    Text("Iniciar Sesión")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(customGreen)
                        .cornerRadius(8)
                        .padding(.horizontal, 25)
                        .font(.system(size: 20))
                }
                .padding(.top, 20)

                Spacer()
                Text("Acceso rápido con:")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                Button(action: {
                }) {
                    Image("google")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(.bottom, 80)

            }
            .padding(.top, 40)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
