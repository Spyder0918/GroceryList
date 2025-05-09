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
    @State private var showErrorAlert = false // New alert for validation errors

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
                // Validate fields
                if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
                    // Set the error message based on which field is missing
                    errorMessage = "Please fill in all fields."
                    showErrorAlert = true
                } else {
                    // Save user info to Keychain
                    let fullName = "\(firstName) \(lastName)"
                    KeychainHelper.save("userFullName", forKey: fullName)
                    KeychainHelper.save("userEmail", forKey: email)
                    KeychainHelper.save("userPassword", forKey: password)

                    // Show success alert
                    showSuccessAlert = true
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success!"),
                    message: Text("Account created. Please log in."),
                    dismissButton: .default(Text("OK")) {
                        // Dismiss SignUpView (go back to LoginView)
                        dismiss()
                    }
                )
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage), // Display the error message
                    dismissButton: .default(Text("OK"))
                )
            }
            // Trigger navigation to LoginView when signup is successful
            NavigationLink("", destination: LoginView(), isActive: $showSuccessAlert).hidden()
        }
        .padding()
    }
}

#Preview {
    SignUpView()
}
