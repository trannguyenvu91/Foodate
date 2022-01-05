//
//  View.swift
//  ArtBoard
//
//  Created by Vu Tran on 2/25/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import SwiftUI

extension View {
    
    func buttonRounded(_ radius: CGFloat = 10) -> some View {
        cornerRadius(radius)
    }
    
    func plainedButton() -> some View {
        buttonStyle(.plain)
    }
    
    func paddingForBorderBackground() -> some View {
        padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 20)
    }
    
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
    
    func stackNavigationViewStyle() -> some View {
        navigationViewStyle(.stack)
    }
    
    func bindErrorAlert<T: BaseViewModel>(to model: ObservedObject<T>.Wrapper) -> some View {
        presentAlert(error: model.error.wrappedValue, isPresented: model.showErrorMessage)
    }
    
    func presentAlert(error: Error?, isPresented: Binding<Bool>) -> some View {
        alert(isPresented: isPresented, content: {
            Alert(error: error)
        })
    }
    
    func asAnyView() -> AnyView {
        AnyView(self)
    }
    
    func width(_ width: CGFloat) -> some View {
        frame(width: width)
    }
    
    func height(_ height: CGFloat) -> some View {
        frame(height: height)
    }
    
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
    
}
