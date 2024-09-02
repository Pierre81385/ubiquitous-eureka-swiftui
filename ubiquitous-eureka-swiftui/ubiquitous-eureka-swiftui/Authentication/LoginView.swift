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
    @State var fireAuthManager: FireAuthViewModel = FireAuthViewModel()

    var body: some View {
        NavigationStack{
            VStack{
                Text("Login").fontWeight(.ultraLight).font(.system(size: 34)).padding()
                Button(action: {
                    showRegistration = true
                }, label: {
                    Text("I don't have an account yet.").tint(.teal).fontWeight(.semibold).font(.system(size: 14))
                }).navigationDestination(isPresented: $showRegistration, destination: {
                    RegisterView().navigationBarBackButtonHidden(true)
                })
                Divider().padding()
                TextField(text: $fireAuthManager.email, label: { Text("Email Address") }).autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never) // Disables auto-capitalization
                    .padding()
                SecureField(text: $fireAuthManager.password, label: { Text("Password") }).padding()
                Button(action: {
                    
                    fireAuthManager.SignInWithEmailAndPassword()
                    fireAuthManager.ListenForUserState()
                    
                }, label: {
                    Text("Submit").foregroundStyle(.black).fontWeight(.ultraLight).font(.system(size: 24))
                }).padding()
                .onChange(of: fireAuthManager.status, {
                    
                    if(fireAuthManager.success == false) {
                        showAlert = true
                        fireAuthManager.email = ""
                        fireAuthManager.password = ""
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

