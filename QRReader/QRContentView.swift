//
//  QRContentView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/24.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI
import SafariServices
import WebKit

struct QRContentView: View {
    var qrContent: String
    
    @State var showSafari = false
    
    var body: some View {
        Button(action: {
            self.showSafari = true
        }) {
            Text(qrContent)
        }.sheet(isPresented: $showSafari) {
            SafariView(url:URL(string: self.qrContent)!)
        }
    }
}

struct QRContentView_Previews: PreviewProvider {
    static var previews: some View {
        QRContentView(qrContent: "test")
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
