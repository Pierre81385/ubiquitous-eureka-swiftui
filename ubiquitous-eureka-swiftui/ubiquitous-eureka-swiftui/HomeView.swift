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
    @State private var logout: Bool = false
    @State private var showQR: Bool = false
    @State var showScanner: Bool = false
    @State var scannedUid: String = ""
    @State var uid: String = ""
    @State var showMap: Bool = false
    @State var showCreate: Bool = false
    @State var showList: Bool = false
    
    var body: some View {
        NavigationStack{
           
                VStack{
                    HStack{
                        Button(action: {
                            authenticationManager.SignOut()
                            authenticationManager.StopListenerForUserState()
                            logout = true
                        }, label: {
                            Image(systemName: "chevron.left").resizable().frame(width: 15, height: 25).tint(.teal)
                        }).navigationDestination(isPresented: $logout, destination: {
                            LoginView().navigationBarBackButtonHidden(true)
                        }).padding()
                        Spacer()
                        Button(action: {
                            showScanner = true
                        }, label: {
                            Image(systemName: "qrcode.viewfinder").resizable().frame(width: 40, height: 40).tint(.teal).padding()
                        }).navigationDestination(isPresented: $showScanner, destination: {
                            QRCodeScan(showScanner: $showScanner, scannedText: $scannedUid)
                        })
                    }
                    Spacer()
                    if(authenticationManager.currentUser != nil) {
                        if(showQR) {
                            QRCodeGen(encode: $uid).background()     
                                .onTapGesture {
                                    showQR = false
                                }
                        } else {
                            AsyncAwaitImageView(imageUrl: (authenticationManager.currentUser?.photoURL)!)
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.6), radius: 15, x: 5, y: 5)
                                .padding()
                                .onTapGesture {
                                    showQR = true
                                }
                        }
                        Text((authenticationManager.currentUser?.displayName)!).fontWeight(.ultraLight)
                        Spacer()
                        HStack{
                            
                            Spacer()
                            Button(action: {
                                showMap = true
                            }, label: {
                                Image(systemName: "map").resizable().frame(width: 40, height: 40).tint(.teal).padding()
                            }).sheet(isPresented: $showMap, content: {
                                UserMapView()
                            })
                            Spacer()
                            Button(action: {
                                showCreate = true
                            }, label: {
                                Image(systemName: "plus.circle").resizable().frame(width: 40, height: 40).tint(.teal).padding()
                            }).sheet(isPresented: $showCreate, content: {
                                CreateContentView(showSheet: $showCreate)
                            })
                            Spacer()
                            Button(action: {
                                showList = true
                            }, label: {
                                Image(systemName: "square.grid.2x2").resizable().frame(width: 40, height: 40).tint(.teal).padding()
                            }).sheet(isPresented: $showList, content: {
                                ListContentView(showSheet: $showList)
                            })
                            Spacer()
                        }
                    } else {
                        ProgressView()
                    }
                    Spacer()
                }.onAppear{
                    authenticationManager.GetCurrentUser()
                    uid = authenticationManager.currentUser?.uid ?? ""
                }
            
        }
    }
}

#Preview {
    HomeView()
}
