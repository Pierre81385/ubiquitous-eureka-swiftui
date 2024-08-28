//
//  LoginView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showAlert: Bool = false
    @State private var showRegistration: Bool = false
    @State private var message: String = ""
    @StateObject var fireAuthManager: FireAuthViewModel = FireAuthViewModel()

    var body: some View {
        NavigationStack{
            VStack{
                Text("Login")
                Button(action: {
                    showRegistration = true
                }, label: {
                    Text("I don't have an account yet.")
                }).navigationDestination(isPresented: $showRegistration, destination: {
                    RegisterView()
                })
                TextField(text: $fireAuthManager.email, label: { Text("Email Address") }).autocorrectionDisabled(true) // Disables autocorrect
                    .textInputAutocapitalization(.none) // Disables auto-capitalization
                    .padding()
                SecureField(text: $fireAuthManager.password, label: { Text("Password") }).padding()
                Button(action: {
                    
                    fireAuthManager.SignInWithEmailAndPassword()
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
            }.onAppear{
                fireAuthManager.SignOut()
                fireAuthManager.StopListenerForUserState()
            }
        }
    }
}

#Preview {
    LoginView()
}

