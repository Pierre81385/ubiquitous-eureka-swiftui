//
//  AuthenticationSuccessView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI
import FirebaseAuth

struct AuthenticationSuccessView: View {
    @Binding var user: User?
    @State private var show: Bool = false
    
    var body: some View {
        VStack{
            Text("Hello, World!")
            Text("ID: \(user?.uid ?? "")")
            Button("Upload", action: {
                show = true
            }).navigationDestination(isPresented: $show, destination: {
                MediaPickerView()
            })
        }
    }
}

//#Preview {
//    AuthenticationSuccessView()
//}
