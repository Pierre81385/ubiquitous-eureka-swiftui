//
//  QRScanner.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/28/24.
//

import SwiftUI
import VisionKit

struct QRCodeScan: View {
    @Binding var key: String?
    @Binding var showScanner: Bool
    @Binding var name: String?
    @State var isShowingScanner = true
    @State private var scannedText = ""
        
        var body: some View {
            
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                ZStack() {
                    DataScannerRepresentable(
                        shouldStartScanning: $isShowingScanner,
                        scannedText: $scannedText,
                        dataToScanFor: [.barcode(symbologies: [.qr, .ean13])]
                    ).onChange(of: scannedText, {
                        print(scannedText)
                        sliceSecret()
                        name = sliceName()
                        showScanner = false
                    })
                    VStack{
                        Spacer()
                        GroupBox(content: {
                            Text("Tap QR Code to Scan").foregroundStyle(.black)
                        }).padding()
                    }
                }.clipShape(.rect(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 10))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))

            } else if !DataScannerViewController.isSupported {
                Text("It looks like this device doesn't support the DataScannerViewController")
            } else {
                Text("It appears your camera may not be available")
            }
        }
    
    //two separate methods to slice key and name
        
    func sliceSecret(){
        let index = scannedText.firstIndex(of: "=")
        let startOffset = scannedText.distance(from: scannedText.startIndex, to: index!)+1
        let startRange = scannedText.index(scannedText.startIndex, offsetBy: startOffset)
        let endRange = scannedText.endIndex
        let range = startRange..<endRange
        let subString = scannedText[range]
        key = String(subString)
    }
    
    func sliceName() -> String? {
        let prefix = "otpauth://totp/"
            let suffix = "?"
            
            // Check if the URL starts with the expected prefix
            guard let prefixRange = scannedText.range(of: prefix) else { return nil }
            
            // Find the range of the substring that starts after the prefix
            let start = scannedText.index(prefixRange.upperBound, offsetBy: 0)
            
            // Find the range of the suffix after the start position
            guard let end = scannedText[start...].range(of: suffix)?.lowerBound else { return nil }
            
            // Extract and return the substring
            let extractedSubstring = String(scannedText[start..<end])
        return extractedSubstring.removingPercentEncoding
    }
}
