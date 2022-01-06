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
    var currentPage: NetworkPage<T>?
    var error: Error?
    
    required init(_ initial: NetworkPage<modelClass>) {
        self.initialPage = initial
        self.currentPage = initial
        append(results: initial.results)
    }
    
    var hasNext: Bool {
        currentPage?.nextURL != nil
    }
    
    func fetchNext() async throws {
        guard !isFetching, hasNext else {
            return
        }
        isFetching = true
        defer {
            isFetching = false
            objectWillChange.send()
        }
        do {
            let nextPage = try await currentPage?.fetchNext()
            if currentPage?.nextURL == initialPage.nextURL {
                items.removeAll()
            }
            append(nextPage)
            currentPage = nextPage
            error = nil
        } catch {
            self.error = error
            throw error
        }
    }
    
    func refresh() async throws {
        isFetching = false
        currentPage = initialPage
        try await fetchNext()
    }
    
    func remove(item: T) {
        items.removeAll(where: { $0 == item })
    }
    
}

extension Paginator: ObservableObject {}

internal extension Paginator {
    
    func append(_ nextPage: NetworkPage<T>?) {
        append(results: nextPage?.results)
        let results = (initialPage.results ?? []) + (nextPage?.results ?? [])
        initialPage = NetworkPage(nextURL: initialPage.nextURL,
                                  results: results,
                                  params: initialPage.params)
    }
    
    func append(results: [T]?) {
        guard let results = results else { return }
        items.append(contentsOf: results)
    }
    
}
