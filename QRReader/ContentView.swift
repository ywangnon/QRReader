//
//  ContentView.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/19.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import SwiftUI

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
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                List(listData) { item in
                    HStack {
                        Image(systemName: item.imageName)
                        Text(item.contents)
                    }
                }
                .navigationBarTitle(Text("QR Reader"))
            }
            Button(action: {
                // action
            }) {
                Text("QR")
                .fontWeight(.bold)
                .font(.title)
                .padding()
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.purple, lineWidth: 5)
                )
            }
            .padding()
            .shadow(color: .red, radius: 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
