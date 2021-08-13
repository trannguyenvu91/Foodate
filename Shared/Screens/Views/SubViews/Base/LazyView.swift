//
//  LazyView.swift
//  ArtBoard
//
//  Created by Vu Tran on 3/30/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView(Text("Hello"))
    }
}
