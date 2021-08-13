//
//  ListViewModel.swift
//  ArtBoard
//
//  Created by Vu Tran on 4/10/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation
import Combine

protocol ListViewModel: ObservableObject {
    associatedtype modelClass: Equatable & ImportableJSONObject
    var paginator: Paginator<modelClass> { get }
    var error: Error? { get set }
    func refresh()
    func didFinishFetching()
    func fetchNext()
}

extension ListViewModel where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    
    var items: [modelClass] {
        paginator.items
    }
    
    func refresh() {
        paginator.refresh(completion: { [weak self] in
            self?.didFinishFetching()
        }) { [weak self] error in
            self?.error = error
            self?.didFinishFetching()
        }
    }
    
    func fetchNext() {
        paginator.fetchNextPage(completion: { [weak self] in
            self?.didFinishFetching()
        }){ [weak self] (error) in
            self?.error = error
            self?.didFinishFetching()
        }
    }
    
    func didFinishFetching() {
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
    }
    
}
