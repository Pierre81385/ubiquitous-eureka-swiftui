//
//  AuthenticationSuccessView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI

struct AuthenticationSuccessView: View {
    @State private var show: Bool = false
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("I'm in!")
            Button("Upload", action: {
                show = true
            }).navigationDestination(isPresented: $show, destination: {
                MediaPickerView()
            })
        }
    }
}

#Preview {
    AuthenticationSuccessView()
}
