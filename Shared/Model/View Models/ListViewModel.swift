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

extension ListViewModel where Self: BaseViewModel  {
    
    var items: [modelClass] {
        paginator.items
    }
    
    func refresh() async {
        do {
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
        
    }
    
    func fetchNext() async {
        do {
            try await paginator.fetchNext()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}
