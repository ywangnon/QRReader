//
//  ContentView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/19.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI
import CodeScanner

struct QRItem: Identifiable {
    var id = UUID()
    var imageName: String
    var contents: String
}

var listData: [QRItem] = [
    QRItem(imageName: "trash.circle.fill", contents: "test1"),
    QRItem(imageName: "person.2.fill", contents: "test2"),
    QRItem(imageName: "car.fill", contents: "test3")
]

struct ContentView: View {
    @State private var isShowingScanner = false
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isShowingScanner = false
       switch result {
       case .success(let code):
        print("Scanning Success", code)
       case .failure(let error):
        print("Scanning failed", error)
       }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                NavigationLink(destination: QRContentView()) {
                    List(listData) { item in
                        HStack {
                            Image(systemName: item.imageName)
                            Text(item.contents)
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
