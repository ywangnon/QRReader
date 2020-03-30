//
//  ContentView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/19.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI
import CoreData
import CodeScanner

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: QRCodes.getAllQRCodes()) var qrCodes: FetchedResults<QRCodes>
    
    @State private var isShowingScanner = false
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let qrCode = QRCodes(context: self.context)
            qrCode.content = code
            qrCode.date = Date()
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        case .failure(let error):
            print("Scanning failed", error)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                NavigationLink(destination: QRContentView()) {
                    List {
                        ForEach(self.qrCodes) { code in
                            Text("code: \(code.content!)")
                        }.onDelete { (indexSet) in
                            let deleteItem = self.qrCodes[indexSet.first!]
                            self.context.delete(deleteItem)
                            
                            do {
                                try self.context.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("QR Reader"))
            }
            Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .frame(width: 48, height: 48, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
            }
            .padding()
            .shadow(color: .red, radius: 5)
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr],
                                simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                                completion: self.handleScan(result:))
            }
        }
    }
}

extension ContentView {
    fileprivate func getAllDatas() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
