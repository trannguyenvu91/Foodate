//
//  Paginator.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/18/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Combine

class Paginator<Item>: NSObject, PaginatorProtocol where Item: Equatable & ImportableJSONObject {
    
    typealias modelClass = Item
    var isFetching: Bool = false
    var items: [Item] = [Item]()
    var currentPage: NetworkPage<Item>?
    var error: Error?
    private(set) var initialPage: NetworkPage<Item>
    var isRefreshing = false
    
    required init(_ initial: NetworkPage<modelClass>) {
        self.initialPage = initial
        self.currentPage = initial
        super.init()
        append(results: initial.results)
    }
    
    var hasNext: Bool {
        currentPage?.nextURL != nil
    }
    
    func fetchNext() async throws {
        guard !isFetching, hasNext else {
            return
        }
        defer {
            isFetching = false
            isRefreshing = false
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
            }
        }
        isFetching = true
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
    
    func remove(item: Item) {
        items.removeAll(where: { $0 == item })
    }
    
}

extension Paginator: ObservableObject {}

internal extension Paginator {
    
    func append(results: [Item]?) {
        guard let results = results else { return }
        items.append(contentsOf: results)
    }
    
}
