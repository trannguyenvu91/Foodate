//
//  Paginator.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/18/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation

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
    
    required init(_ initial: NetworkPage<modelClass>) {
        self.initialPage = initial
        self.currentPage = initial
    }
    
    var hasNext: Bool {
        currentPage?.nextURL != nil
    }
    
    func fetchNext() async throws {
        guard !isFetching, hasNext else {
            return
        }
        isFetching = true
        currentPage = try await currentPage?.fetchNext()
        isFetching = false
    }
    
    func refresh() async throws {
        reset()
        try await fetchNext()
    }
    
    func reset() {
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
