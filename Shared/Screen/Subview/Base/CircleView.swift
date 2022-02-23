//
//  CircleView.swift
//  JustDate
//
//  Created by Vu Tran on 5/11/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import SwiftUI

struct CircleView<Content: View>: View {
    
    let build: () -> Content
    var lineWidth: CGFloat = 4
    var lineColor = Color.white
    
    init(_ build: @autoclosure @escaping () -> Content,
         lineWidth: CGFloat = 4,
         lineColor: Color = .white) {
        self.build = build
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
    var body: some View {
        build()
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(lineColor, lineWidth: lineWidth)
        )
    }
    
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleView(Image("turtlerock"))
    }
}
