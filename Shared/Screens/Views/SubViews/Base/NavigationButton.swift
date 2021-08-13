//
//  SwiftUIView.swift
//  ArtBoard
//
//  Created by Vu Tran on 3/30/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import SwiftUI

extension View {
    func push<Destination>(_ destination: Destination, activate: Binding<Bool>) -> some View where Destination: View {
        ZStack {
            self
            NavigationLink(destination: destination, isActive: activate) {
                EmptyView()
            }
            .hidden()
            .frame(width: 0, height: 0)
            .disabled(true)
        }
    }
}

struct NavigationButton<Content, Destination>: View where Content: View, Destination: View {
    
    let content: Content
    let destination: Destination
    @State private var isPressed: Bool = false
    
    init(destination: Destination, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.destination = destination
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: self.destination, isActive: self.$isPressed) {
                EmptyView()
            }
            .hidden()
            .frame(width: 0, height: 0)
            .disabled(true)
            Button(action: {
                self.isPressed.toggle()
            }) {
                content
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(destination: Text("Great")) {
            Text("Press this")
        }
    }
}
