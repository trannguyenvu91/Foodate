//
//  Paginator.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/18/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Combine

class Paginator <T>: PaginatorProtocol where T: Equatable & ImportableJSONObject {
    
    typealias modelClass = T
    var isFetching: Bool = false
    var items: [T] = [T]()
    fileprivate var initialPage: NetworkPage<T>
    var currentPage: NetworkPage<T>? {
        didSet {
            if oldValue?.nextURL == initialPage.nextURL &&
                oldValue?.results == initialPage.results {
                items.removeAll()
            }
            append(results: currentPage?.results)
        }
    }
    var cancelableSet: Set<AnyCancellable> = []

    required init(_ initial: NetworkPage<modelClass>) {
        self.initialPage = initial
        self.currentPage = initial
    }
    
    var isCanceled = false {
        didSet {
            if isCanceled {
                cancelableSet.forEach({ $0.cancel() })
            }
        }
    }
    
    var hasNext: Bool {
        return currentPage?.nextURL != nil
    }
    
    func fetchNextPage(completion: CompletionBlock?, failure: FailureBlock?) {
        guard !isFetching, hasNext else {
            return
        }
        isFetching = true
        currentPage?.fetchNext().sink(receiveCompletion: { [weak self] (receive) in
            self?.isFetching = false
            switch receive {
            case .failure(let error):
                failure?(error)
            default:
                completion?()
                break
            }
        }, receiveValue: { (page) in
            self.currentPage = page
        })
        .store(in: &cancelableSet)
    }
    
    func refresh(completion: CompletionBlock?, failure: FailureBlock?) {
        isCanceled = true
        isFetching = false
        currentPage = initialPage
        fetchNextPage(completion: completion, failure: failure)
    }
    
    func reset() {
        isCanceled = true
        isFetching = false
        items.removeAll()
        currentPage = initialPage
    }
    
    func remove(item: T) {
        items.removeAll(where: { $0 == item })
    }
    
}

extension Paginator {
    
    fileprivate func append(results: [T]?) {
        guard let results = results else { return }
        items.append(contentsOf: results)
    }

}
