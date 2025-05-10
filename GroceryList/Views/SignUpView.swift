//
//  SignUpView.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 5/9/25.
//
import SwiftUI

struct SignUpView: View {
    // Form fields
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    // Alert control
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false

    // Error message
    @State private var errorMessage = ""

    // Dismiss view (go back to login)
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .padding(.bottom, 40)

            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
                    errorMessage = "Please fill in all fields."
                    showErrorAlert = true
                } else {
                    // 1. Load existing accounts
                    var accounts = KeychainHelper.loadAccounts()
                    
                    // 2. Add the new account
                    let newAccount = UserAccount(email: email, password: password)
                    accounts.append(newAccount)
                    
                    // 3. Save updated accounts list
                    KeychainHelper.saveAccounts(accounts)
                    
                    // Show success alert
                    showSuccessAlert = true
                }
            })
 {
                Text("Sign Up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert("Success!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss() // <-- Dismiss and go back to login
                }
            } message: {
                Text("Account created. Please log in.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
