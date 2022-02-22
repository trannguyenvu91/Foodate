//
//  PaginatorProtocol.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import SwiftUI

protocol Searchable {
    var filter: JSON? { get }
    func search(_ term: JSON) async throws
    func clearSearch()
}

protocol Pagable {
    var hasNext: Bool { get }
    var isFetching: Bool { get }
    var error: Error? { get set }
    func fetchNext() async throws
    func refresh() async throws
}

protocol PaginatorProtocol: NSObjectProtocol, Pagable {
    associatedtype modelClass: ImportableJSONObject
    init(_ initial: NetworkPage<modelClass>)
    var items: [modelClass] { get set }
    func remove(item: modelClass)
}

extension PaginatorProtocol where Self: NSObject {
    
    func insert(_ item: modelClass, at index: Int = 0) {
        items.insert(item, at: index)
    }
    
}
