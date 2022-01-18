//
//  SearchablePaginator.swift
//  Foodate
//
//  Created by Vu Tran on 1/18/22.
//

import UIKit

class SearchablePaginator<Item>: Paginator<Item> where Item: Equatable & ImportableJSONObject {
    internal var placeholderPage: NetworkPage<Item>?
    internal var searchTerm: String?
    
}

extension SearchablePaginator: SearchablePaginatorProtocol {
    var filter: JSON? {
        var json = initialPage.params ?? [:]
        if let searchTerm = searchTerm {
            json["search"] = searchTerm
        }
        return json
    }
    
    func search(_ term: String) async throws {
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
