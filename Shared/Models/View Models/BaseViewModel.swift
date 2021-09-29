//
//  BaseViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Combine
import Foundation

class BaseViewModel: NSObject, ObservableObject {
    
    @Published var showErrorMessage = false
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    var cancelableSet = [AnyCancellable]()
    var error: Error? {
        didSet {
            showErrorMessage = error != nil
        }
    }
    
    func asyncDo(_ action: @escaping () async throws -> Void) {
        Foodate.asyncDo(action) { [unowned self] err in
            DispatchQueue.main.async {
                error = err
            }
        }
    }
    
    func bind(_ willChanges: [ObservableObjectPublisher]) {
        Publishers.MergeMany(willChanges)
            .eraseToAnyPublisher()
            .sink { [weak self] _ in
                self?.objectWillChange.send()
        }
        .store(in: &cancelableSet)
    }
    
}

func asyncDo(_ action: @escaping () async throws -> Void, failed: ((Error) -> Void)? = nil) {
    Task {
        do {
            try await action()
        } catch {
            failed?(error)
        }
    }
}
