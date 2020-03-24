//
//  QRContentView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/24.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI

struct QRContentView: View {
    var body: some View {
        Text("hi")
            .onAppear {
                print("QRView On")
        }
        .onDisappear {
            print("QRView Off")
        }
    }
}

struct QRContentView_Previews: PreviewProvider {
    static var previews: some View {
        QRContentView()
    }
}
