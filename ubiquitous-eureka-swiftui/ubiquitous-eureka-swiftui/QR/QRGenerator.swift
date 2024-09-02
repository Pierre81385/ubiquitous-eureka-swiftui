//
//  QRGenerator.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/28/24.
//

import SwiftUI

struct QRCodeGen: View {
    @Binding var encode: String
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 300, height: 300)
                    .shadow(color: .black.opacity(0.6), radius: 15, x: 5, y: 5)
                Image(uiImage: UIImage(data: getQRCodeDate(text: encode)!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                
            }.padding()
        }
        
        func getQRCodeDate(text: String) -> Data? {
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
            let data = text.data(using: .ascii, allowLossyConversion: false)
            filter.setValue(data, forKey: "inputMessage")
            guard let ciimage = filter.outputImage else { return nil }
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledCIImage = ciimage.transformed(by: transform)
            let uiimage = UIImage(ciImage: scaledCIImage)
            return uiimage.pngData()!
        }
}

//#Preview {
//    QRCodeGen()
//}
