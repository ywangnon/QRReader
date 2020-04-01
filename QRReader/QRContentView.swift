//
//  QRContentView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/24.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI
import SafariServices

struct QRContentView: View {
    var qrContent: String
    var date: String
    
    @State var showSafari = false
    
    var body: some View {
        Form {
            Text("QR 내용")
                .font(.headline)
            HStack {
                Button(action: {
                    self.showSafari = true
                }) {
                    Text(qrContent)
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url:URL(string: self.qrContent) ?? URL(string: "http://www.google.com")!)
                }
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = self.qrContent
                }) {
                    Image(systemName: "doc.on.doc.fill")
                }
                .background(Color.blue)
                .shadow(color: .red, radius: 5)
            }
            
            Text("생성일")
                .font(.headline)
            
            Text(date)
                .font(.body)
        }.navigationBarTitle("상세 내용!!!")
    }
}

extension QRContentView {
    func googleSearch(_ str: String) -> URL {
        if URL(string: str) != nil {
            let urlString = str.replacingOccurrences(of: " ", with: "+")
            let searchURL = URL(string: "http://www.google.com/search?q=\(urlString)")
            return searchURL!
        }
        if URL(string: str)?.scheme == nil {
            let urlString = str.replacingOccurrences(of: " ", with: "+")
            let searchURL = URL(string: "http://www.google.com/search?q=\(urlString)")
            return searchURL!
        }
        return URL(string: "http://www.google.com")!
    }
}

struct QRContentView_Previews: PreviewProvider {
    static var previews: some View {
        QRContentView(qrContent: "test", date: "1999.01.01")
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {

        if !(["http", "https"].contains(url.scheme?.lowercased())) {
            let appendedLink = "http://\(url)"

            return SFSafariViewController(url: URL(string: appendedLink)!)
        } else {
            return SFSafariViewController(url: url)
        }
        
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SafariView>) {

    }

}
