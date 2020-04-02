//
//  CreateQRCodeView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/04/02.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI
import CoreData

struct CreateQRCodeView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var createQRContent = ""
    
    var body: some View {
        VStack {
            Text("큐알 내용!")
                .font(.largeTitle)
            Spacer()
            GeometryReader { (geometry) in
                TextField("큐알 내용~", text: self.$createQRContent)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                    .background(Color.gray)
            }
            Button(action: {
                let qrCode = QRCodes(context: self.context)
                print(qrCode)
                qrCode.content = self.createQRContent
                qrCode.date = Date()
                qrCode.isRead = false
                
                do {
                    try self.context.save()
                } catch {
                    print("생성 에러")
                    print(error)
                }
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("큐알 생성")
            }
            
        }
    }
}

struct CreateQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRCodeView()
    }
}
