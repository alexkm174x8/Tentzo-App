//
//  SignUpView.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 28/09/24.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @AppStorage("uid") var userID: String = ""  // UID del user
    @Binding var currentShowingView: String
    let customGreen = Color(red: 127 / 255, green: 194 / 255, blue: 151 / 255)
    
    // UserService instance to handle Firestore document creation
    private let userService = UserService()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Vive el Tentzo")
                .font(.title2)
                .foregroundColor(customGreen)
                .padding(.bottom, 10)
            
            Text("Registrarse")
                .font(.system(size: 45))
                .foregroundColor(.black)
                .padding(.bottom, 5)
            
            TextField("Nombre Completo", text: $fullName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 20)
                .foregroundColor(.black)
                .autocapitalization(.words)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .foregroundColor(.black)
            
            SecureField("Contraseña", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .foregroundColor(.black)
            
            SecureField("Repetir Contraseña", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .foregroundColor(.black)
            
            Button(action: {
                signUpUser()
            }) {
                Text("Registrarse")
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
            
            HStack {
                Text("¿Ya tienes una cuenta?")
                    .foregroundColor(.gray)
                
                Button(action: {
                    withAnimation {
                        currentShowingView = "login"
                    }
                }) {
                    Text("Inicia Sesión")
                        .fontWeight(.bold)
                        .foregroundColor(customGreen)
                }
            }
            .padding(.bottom, 10)
            
            Text("Acceso rápido con:")
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            Button(action: {
                // aqui lo de google
            }) {
                Image("google")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .padding(.bottom, 60)
            
        }
        .padding(.top, 40)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.light)
    }
    
    // MARK: - Helper Methods
    
    private func signUpUser() {
        guard password == confirmPassword else {
            print("Las contraseñas no coinciden.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error al crear la cuenta: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                userID = user.uid // Store the user's UID
                print("Cuenta creada exitosamente, UID: \(user.uid)")
                
                // Call UserService to create Firestore document for the new user
                userService.createUserDocument(user: user, fullName: fullName)
                
                // Navigate to login view or main screen
                withAnimation {
                    currentShowingView = "login"
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(currentShowingView: .constant("signup"))
    }
}
