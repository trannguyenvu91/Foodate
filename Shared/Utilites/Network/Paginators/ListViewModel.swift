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
    func refresh() async throws
    func fetchNext() async throws
}

extension ListViewModel where Self.ObjectWillChangePublisher == ObservableObjectPublisher  {
    
    var items: [modelClass] {
        paginator.items
    }
    
    func refresh() async throws {
        try await paginator.refresh()
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func fetchNext() async throws {
        try await paginator.fetchNext()
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
}
