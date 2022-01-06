//
//  AsyncButton.swift
//  Foodate
//
//  Created by Vu Tran on 12/27/21.
//

import SwiftUI

struct AsyncButton<Content: View>: View {
    
    @State var isLoading = false
    @ViewBuilder var content: () -> Content
    @Binding var error: Error?
    var task: () async throws -> Void
    
    init(task: @escaping () async throws -> Void,
         error: Binding<Error?>,
         _ content: @escaping () -> Content) {
        self.content = content
        self._error = error
        self.task = task
    }
    
    var body: some View {
        Button(action: {
            executeTask()
        }) {
            ZStack {
                content()
                    .opacity(isLoading ? 0 : 1)
                if isLoading {
                    ProgressView()
                }
            }
        }
        .disabled(isLoading)
    }
    
    func executeTask() {
        let _ = Task {
            do {
                try await task()
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
        isLoading = true
    }
    
}
