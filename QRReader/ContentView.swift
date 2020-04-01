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
                                        Image(systemName: "qrcode.viewfinder")
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
                                simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
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
        //        formatter.dateFormat = .none
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
