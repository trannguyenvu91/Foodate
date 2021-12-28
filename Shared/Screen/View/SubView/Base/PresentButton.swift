//
//  PresentButton.swift
//  Foodate
//
//  Created by Vu Tran on 03/08/2021.
//

import SwiftUI

struct PresentButton<Content, Destination>: View where Content: View, Destination: View {
    
    let content: Content
    let destination: Destination
    @State private var isPressed: Bool = false
    
    init(destination: Destination, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.destination = destination
    }
    
    var body: some View {
        Button(action: {
            self.isPressed.toggle()
        }) {
            content
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPressed, content: {
            destination
        })
    }
    
}

struct PresentButton_Previews: PreviewProvider {
    static var previews: some View {
        PresentButton(destination: Text("Great")) {
            Text("Press this")
        }
    }
}
