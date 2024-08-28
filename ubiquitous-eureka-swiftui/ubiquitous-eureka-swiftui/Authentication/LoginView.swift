//
//  LoginView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State var fireAuthManager: FireAuthViewModel = FireAuthViewModel()

    var body: some View {
        NavigationStack{
            VStack{
                Text("Login")
                TextField(text: $fireAuthManager.email, label: { Text("Email Address") }).padding()
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

