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
    @State private var isAddingQR = false
    
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .singleLine
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let qrCode = QRCodes(context: self.context)
            qrCode.content = code
            qrCode.date = Date()
            qrCode.isRead = true
            
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
                List {
                    ForEach(self.qrCodes) { code in
                        NavigationLink(
                            destination: QRContentView(
                                qrContent: code.content!,
                                date: self.converDateToString(code.date!, .detailView))) {
                                    HStack {
                                        Image(systemName: code.isRead ? "qrcode.viewfinder" : "pencil.and.outline")
                                        VStack(alignment: .leading) {
                                            Text("\(code.content!)")
                                                .font(.subheadline)
                                            Text(self.converDateToString(code.date!, .mainList))
                                                .font(.footnote)
                                                .foregroundColor(Color.green)
                                        }
                                    }
                        }
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
                .navigationBarItems(trailing:
                    Button(action: {
                        self.isAddingQR.toggle()
                    }) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .padding()
                    }.sheet(isPresented: $isAddingQR, onDismiss: {
                        print("Code executed when the sheet dismisses")
                    }) {
                        CreateQRCodeView().environment(\.managedObjectContext, self.context)
                    }
                )
                    .navigationBarTitle(Text("큐알 리더기!!!"))
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
                                simulatedData: "https://www.google.co.kr",
                    completion: self.handleScan(result:))
            }
        }
    }
}

extension ContentView {
    enum CustomDateFormat: String {
        case mainList = "d MMM y"
        case detailView = "HH:mm E, d MMM y"
    }
    
    func converDateToString(_ date: Date, _ format: CustomDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
