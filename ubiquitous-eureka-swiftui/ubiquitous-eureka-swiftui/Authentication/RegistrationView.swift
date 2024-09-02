//
//  RegistrationView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var showLogin: Bool = false
    @State private var verifyPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State var fireAuthManager: FireAuthViewModel = FireAuthViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Register").fontWeight(.ultraLight).font(.system(size: 34)).padding()
                Button(action: {
                    showLogin = true
                }, label: {
                    Text("I already have an account.").tint(.teal).fontWeight(.semibold).font(.system(size: 14))
                }).navigationDestination(isPresented: $showLogin, destination: {
                    LoginView().navigationBarBackButtonHidden(true)
                })
                Divider().padding()
                TextField(text: $fireAuthManager.email, label: { Text("Email Address") }).autocorrectionDisabled(true) // Disables autocorrect
                    .textInputAutocapitalization(.never) // Disables auto-capitalization
                    .padding()
                SecureField(text: $fireAuthManager.password, label: { Text("Password") }).padding()
                SecureField(text: $verifyPassword, label: { Text("Verify Password") }).padding()
                
                Button(action: {
                    
                    fireAuthManager.CreateUser()
                    fireAuthManager.ListenForUserState()
                    
                }, label: {
                    Text("Submit").foregroundStyle(.black).fontWeight(.ultraLight).font(.system(size: 24))
                }).padding()
                .onChange(of: fireAuthManager.status, {
                    
                    if(fireAuthManager.success == false) {
                        fireAuthManager.email = ""
                        fireAuthManager.password = ""
                        verifyPassword = ""
                        showAlert = true
                    }
                })
                .navigationDestination(isPresented: $fireAuthManager.loggedIn, destination: {
                    UserSetupView().navigationBarBackButtonHidden(true)
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
