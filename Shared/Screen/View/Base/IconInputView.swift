//
//  IconInputView.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import SwiftUI

struct IconInputView<Content: View>: View {
    let build: () -> Content
    let icon: Image
    
    init(_ icon: Image,
         build: @autoclosure @escaping () -> Content) {
        self.icon = icon
        self.build = build
    }
    
    var body: some View {
        HStack {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.blue)
            build()
        }
        .padding(8)
        .overlay(
            Capsule()
                .stroke(Color.lightGray, lineWidth: 1)
        )
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 8)
    }
}

struct IconInputView_Previews: PreviewProvider {
    static var previews: some View {
        IconInputView(Image(systemName: "lock"), build: EmptyView())
    }
}
