//
//  QRGenerator.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/28/24.
//

import SwiftUI

struct QRCodeGen: View {
    @State private var text = ""
        
        var body: some View {
            VStack {
                Image(uiImage: UIImage(data: getQRCodeDate(text: text)!)!)
                    .resizable()
                    .frame(width: 200, height: 200)
                Text("Enter text to encode").foregroundStyle(.white).fontWeight(.light)
                TextField("QR code content", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
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

#Preview {
    QRCodeGen()
}
