//
//  RegistrationView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var verifyPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @StateObject var fireAuthManager: FireAuthViewModel = FireAuthViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Register")
                TextField(text: $fireAuthManager.email, label: { Text("Email Address") }).autocorrectionDisabled(true) // Disables autocorrect
                    .textInputAutocapitalization(.never) // Disables auto-capitalization
                    .padding()
                SecureField(text: $fireAuthManager.password, label: { Text("Password") }).padding()
                SecureField(text: $verifyPassword, label: { Text("Verify Password") }).padding()
                Button(action: {
                    
                    fireAuthManager.CreateUser()
                    fireAuthManager.ListenForUserState()
                    
                }, label: {
                    Text("Submit")
                }).onChange(of: fireAuthManager.status, { oldValue, newValue in
                    message = newValue
                    if(fireAuthManager.success == false) {
                        showAlert = true
                    }
                })
                .navigationDestination(isPresented: $fireAuthManager.loggedIn, destination: {
                    AuthenticationSuccessView()
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(fireAuthManager.status),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
