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
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @AppStorage("uid") var userID: String = ""  // UID del usuario
    @Binding var currentShowingView: String
    let customGreen = Color(red: 127 / 255, green: 194 / 255, blue: 151 / 255)

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
                .onChange(of: fullName) { _ in
                    capitalizeFullName()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 20)
                .foregroundColor(.black)
                .autocapitalization(.words)
            
            TextField("Email", text: $email, onCommit: validateEmail)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .foregroundColor(.black)
            
            HStack {
                if showPassword {
                    TextField("Contraseña", text: $password, onCommit: validatePassword)
                } else {
                    SecureField("Contraseña", text: $password, onCommit: validatePassword)
                }
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 25)
            .padding(.top, 10)
            .foregroundColor(.black)
            
            HStack {
                if showConfirmPassword {
                    TextField("Repetir Contraseña", text: $confirmPassword, onCommit: checkPasswordMatch)
                } else {
                    SecureField("Repetir Contraseña", text: $confirmPassword, onCommit: checkPasswordMatch)
                }
                Button(action: { showConfirmPassword.toggle() }) {
                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
    private func capitalizeFullName() {
        fullName = fullName.capitalized
    }
    
    private func validateEmail() {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        let matches = regex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        if matches == nil {
            alertMessage = "Por favor, introduce un correo electrónico válido."
            showAlert = true
        }
    }
    
    private func validatePassword() {
        if password.count < 6 {
            alertMessage = "La contraseña debe tener al menos 6 caracteres."
            showAlert = true
        }
    }
    
    private func checkPasswordMatch() {
        if password != confirmPassword {
            alertMessage = "Las contraseñas no coinciden."
            showAlert = true
        }
    }
    
    private func signUpUser() {
        guard password == confirmPassword else {
            alertMessage = "Las contraseñas no coinciden."
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Error al crear la cuenta: \(error.localizedDescription)"
                showAlert = true
            } else if let user = authResult?.user {
                userID = user.uid
                userService.createUserDocument(user: user, fullName: fullName)
                
                withAnimation {
                    currentShowingView = "login"
                }
            }
        }
    }
}
