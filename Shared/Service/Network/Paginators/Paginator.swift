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
    private var isRefreshing = false
    
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
            isRefreshing = false
            objectWillChange.send()
        }
        do {
            let nextPage = try await currentPage?.fetchNext()
            if isRefreshing {
                items.removeAll()
                append(results: initialPage.results)
            }
            append(results: nextPage?.results)
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
        isRefreshing = true
        try await fetchNext()
    }
    
    func remove(item: T) {
        items.removeAll(where: { $0 == item })
    }
    
}

extension Paginator: ObservableObject {}

internal extension Paginator {
    
    func append(results: [T]?) {
        guard let results = results else { return }
        items.append(contentsOf: results)
    }
    
}
