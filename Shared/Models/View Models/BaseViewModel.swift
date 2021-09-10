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
    
    func execute<T>(publisher: NetworkPublisher<T>, success: ((T) -> Void)? = nil) {
        publisher.sink { (result) in
            self.error = result.error
        } receiveValue: { object in
            success?(object)
        }
        .store(in: &cancelableSet)
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
