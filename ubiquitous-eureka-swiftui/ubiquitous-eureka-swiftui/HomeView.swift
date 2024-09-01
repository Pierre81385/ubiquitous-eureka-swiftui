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
            
            if(authenticationManager.currentUser == nil) {
                VStack{
                    ProgressView()
                    Text("Loading User")
                }
            } else {
                VStack{
                    AsyncAwaitImageView(imageUrl: (authenticationManager.currentUser?.photoURL)!)
                        .scaledToFill()
                        .frame(width: 325, height: 325)
                        .clipShape(Circle())
                    Text((authenticationManager.currentUser?.displayName)!)
                    Text((authenticationManager.currentUser?.email)!)
                }
            }
               
        }.onAppear{
            authenticationManager.GetCurrentUser()
        }
    }
}

//#Preview {
//    HomeView()
//}
