//
//  HomeView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/29/24.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State var authenticationManager: FireAuthViewModel = FireAuthViewModel()
    
    var body: some View {
        VStack{
            HStack
            {
                AsyncAwaitImageView(imageUrl: (authenticationManager.currentUser?.photoURL)!)
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                Text(authenticationManager.currentUser?.displayName ?? "")
            }
        }.onAppear{
            authenticationManager.GetCurrentUser()
        }
    }
}

//#Preview {
//    HomeView()
//}
