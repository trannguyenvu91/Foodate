//
//  SearchablePaginator.swift
//  Foodate
//
//  Created by Vu Tran on 1/18/22.
//

import Foundation

class SearchablePaginator<Item>: Paginator<Item> where Item: Equatable & ImportableJSONObject {
    internal var placeholderPage: NetworkPage<Item>?
    internal var searchTerm: JSON?
    
    override func refresh() async throws {
        if let searchTerm = searchTerm {
            try await search(searchTerm)
            return
        }
        try await super.refresh()
    }
}

extension SearchablePaginator: Searchable {
    var filter: JSON? {
        var json = initialPage.params ?? [:]
        json.merge(searchTerm ?? [:], uniquingKeysWith: { $1 })
        return json
    }
    
    func search(_ term: JSON) async throws {
        if searchTerm == nil {
            placeholderPage = NetworkPage<Item>(nextURL: currentPage?.nextURL, results: items, params: filter)
        }
        searchTerm = term
        isRefreshing = false
        isFetching = false
        items.removeAll()
        currentPage = NetworkPage<Item>(nextURL: initialPage.nextURL, params: filter)
        try await fetchNext()
    }

    func clearSearch() {
        guard searchTerm != nil else {
            return
        }
        defer {
            objectWillChange.send()
        }
        isRefreshing = false
        isFetching = false
        searchTerm = nil
        items.removeAll()
        append(results: placeholderPage?.results)
        currentPage = placeholderPage
    }
    
}
