import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false // Estado para controlar el loading
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
                        isLoading = true // Inicia el loading
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            isLoading = false // Detiene el loading
                            if let error = error {
                                print("Error al iniciar sesión: \(error.localizedDescription)")
                            } else if let authResult = authResult {
                                userID = authResult.user.uid
                                print("Inicio de sesión exitoso, UID: \(authResult.user.uid)")
                                // Aquí puedes navegar a otra vista si es necesario
                            }
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentShowingView: .constant("login"))
    }
}
