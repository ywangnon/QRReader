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
            GeometryReader { geometry in
                TextField("만드실 내용을 입력해주세요", text: self.$createQRContent)
//                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0))
                    .lineLimit(3)
                    .font(.title)
            }.padding()
//            GeometryReader { (geometry) in
//                TextField("큐알 내용~", text: self.$createQRContent)
//                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0))
//                    .padding()
//                    .frame(width: geometry.size.width,
//                           height: geometry.size.height)
//            }
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
                Spacer()
                Text("큐알 생성")
                    .font(.headline)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding(.vertical, 10.0)
            .background(Color.red)
            .cornerRadius(4.0)
            .padding(.horizontal, 50)
        }
    }
}

struct CreateQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRCodeView()
    }
}
