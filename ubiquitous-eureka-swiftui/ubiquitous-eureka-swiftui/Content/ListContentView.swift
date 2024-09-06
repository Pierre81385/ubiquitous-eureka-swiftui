//
//  ListContentView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import SwiftUI
import FirebaseFirestore

struct ListContentView: View {
    @Binding var showSheet: Bool
    @State private var contentManager: ContentViewModel = ContentViewModel()
    
    var body: some View {
        VStack{
            Button(action: {
                showSheet = false
            }, label: {
                Image(systemName: "chevron.compact.down").tint(.black)
            }).padding()
            ScrollView(content: {
                ForEach(contentManager.queriedContent.indices, id: \.self) {
                    index in
                    GroupBox(contentManager.queriedContent[index].title, content: {
                        VStack{
                            Text(contentManager.queriedContent[index].description).fontWeight(.ultraLight)
                            ForEach(contentManager.queriedContent[index].images, id: \.self) { image in
                                
                                AsyncAwaitImageView(imageUrl: URL(string: image)!)
                                    .scaledToFill()
                                    .frame(width: 325)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            }
                            
                        }.padding()
                    }).padding()
                }
            }).onAppear{
                Task{
                    await contentManager.getContents()
                }
            }
        }
    }
}

//#Preview {
//    ListContentView()
//}
