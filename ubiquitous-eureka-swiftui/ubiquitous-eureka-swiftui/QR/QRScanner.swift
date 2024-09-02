//
//  QRScanner.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/28/24.
//

import SwiftUI
import VisionKit

struct QRCodeScan: View {
    @Binding var showScanner: Bool
    @Binding var scannedText: String
    @State var isShowingScanner = true
        
        var body: some View {
            
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                ZStack() {
                    DataScannerRepresentable(
                        shouldStartScanning: $isShowingScanner,
                        scannedText: $scannedText,
                        dataToScanFor: [.barcode(symbologies: [.qr])]
                    ).onChange(of: scannedText, {
                        print(scannedText)
                        showScanner = false
                    })
                    VStack{
                        Spacer()
                        GroupBox(content: {
                            HStack{
                                Button(action: {
                                    showScanner = false
                                }, label: {
                                    Image(systemName: "chevron.backward").tint(.teal)
                                })
                                Text("Tap QR Code to Scan").foregroundStyle(.teal)
                            }
                        }).padding()
                    }
                }.clipShape(.rect(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 10))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))

            } else if !DataScannerViewController.isSupported {
                VStack{
                    Text("It looks like this device doesn't support the DataScannerViewController")
                    Button(action: {
                        showScanner = false
                    }, label: {
                        Text("OK")
                    })
                }
            } else {
                Text("Please enable camera access!")
            }
        }
}
