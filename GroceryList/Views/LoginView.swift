import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoginSuccessful = false
    @State private var showSignUp = false
    @State private var showLoginError = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("login_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 50)
                
                TextField("Email", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    handleLogin()
                }) {

                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                
                Button(action: {
                    showSignUp = true
                }) {
                    Text("Create Account")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                if isLoginSuccessful {
                    Text("Login Successful!")
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Log In")
            .navigationDestination(isPresented: $isLoginSuccessful) {
                ShoppingListView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .alert("Login Failed", isPresented: $showLoginError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleLogin() {
        let accounts = KeychainHelper.loadAccounts()
        
        if accounts.contains(where: { $0.email.lowercased() == username.lowercased() && $0.password == password }) {
            isLoginSuccessful = true
        } else {
            errorMessage = "Invalid email or password. Please try again."
            showLoginError = true
        }
    }

        
        
        }
#Preview {
    LoginView()
    }

