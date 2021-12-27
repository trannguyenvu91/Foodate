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
    private var action: () -> Void
    
    init(perform action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !didLoad else { return }
            didLoad = true
            action()
        }
    }
    
}

struct ViewDidLoadTaskModifier: ViewModifier {
    
    @State private var didLoad = false
    private var task: () async throws -> Void
    @Binding var error: Error?
    
    init(perform task: @escaping () async throws -> Void, error: Binding<Error?>) {
        self.task = task
        self._error = error
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !didLoad else { return }
            didLoad = true
            Task {
                do {
                    try await task()
                } catch {
                    self.error = error
                }
            }
        }
    }
    
}

extension View {
    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
    func taskOnLoad(error: Binding<Error?>,
                    _ task: @escaping () async throws -> Void) -> some View {
        modifier(ViewDidLoadTaskModifier(perform: task, error: error))
    }
    
}
