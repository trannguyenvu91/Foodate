//
//  ViewDidLoadModifier.swift
//  Foodate
//
//  Created by Vu Tran on 08/10/2021.
//

import SwiftUI
import Combine
import CoreStore

struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    private var action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !didLoad else { return }
            didLoad = true
            action?()
        }
    }
    
}

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
