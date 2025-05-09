import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoginSuccessful = false
    @State private var showSignUp = false // <-- Track if user wants to create account
    @State private var isNavigatingToShoppingList = false // <-- Declare the navigation state variable

    
    var body: some View {
        NavigationStack { // <-- Add NavigationStack
            VStack {
                Image("login_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 50)
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Handle login action here
                    isLoginSuccessful = true
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                // Create Account Button
                NavigationLink(destination: SignUpView(), isActive: $showSignUp) {
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("Create Account")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                
                if isLoginSuccessful {
                    Text("Login Successful!")
                        .foregroundColor(.green)
                }
                NavigationLink(destination: ShoppingListView(), isActive: $isLoginSuccessful) {
                    EmptyView()
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Log In")// <-- Title of the screen
                .navigationDestination(isPresented: $isNavigatingToShoppingList) {
                    ShoppingListView() // Make sure you have a ShoppingListView to navigate to
                    
                }
                .navigationDestination(isPresented: $showSignUp) {
                    SignUpView()
                    
                }
            }
        }
    }
    
}

#Preview {
    LoginView()
}
