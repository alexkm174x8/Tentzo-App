import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @AppStorage("uid") var userID: String = ""
    @Binding var currentShowingView: String
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
                    Button(action: {
                        withAnimation {
                            currentShowingView = "signup"
                        }
                    }) {
                        Text("Regístrate")
                            .foregroundColor(customGreen)
                            .fontWeight(.bold)
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
                    .onChange(of: email) { newValue in
                        email = newValue.lowercased()
                    }
                    .onSubmit {
                        validateEmail()
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
                
                if isLoading {
                    ProgressView("Iniciando sesión...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Button(action: {
                        validateEmail()
                        logInUser()
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
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                
                Spacer()
                Text("Acceso rápido con:")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                Button(action: {
                    // Acción para Google
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
    
    private func validateEmail() {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        let matches = regex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        if matches == nil {
            alertMessage = "Por favor, introduce un correo electrónico válido."
            showAlert = true
        }
    }
    
    private func logInUser() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "El correo y la contraseña son obligatorios."
            showAlert = true
            return
        }
        
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            isLoading = false
            if let error = error {
                alertMessage = "Correo o contraseña incorrectos. Intenta de nuevo."
                showAlert = true
                print("Login error: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                userID = user.uid
                print("Inicio de sesión exitoso, UID: \(user.uid)")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentShowingView: .constant("login"))
    }
}

