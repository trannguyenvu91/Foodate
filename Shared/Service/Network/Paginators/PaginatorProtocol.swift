//
//  PaginatorProtocol.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import SwiftUI

protocol ImportableJSONObject {
    static func importObject(from source: JSON) throws -> Self
}

extension ImportableJSONObject {
    
    static func importObjects(from sourceArry: [JSON]) throws -> [Self] {
        try sourceArry.map({ try importObject(from: $0) })
    }
}

protocol PaginatorProtocol {
    associatedtype modelClass: ImportableJSONObject
    init(_ initial: NetworkPage<modelClass>)
    var hasNext: Bool { get }
    var isFetching: Bool { get }
    var items: [modelClass] { get set }
    var error: Error? { get set }
    
    func fetchNext() async throws
    func refresh() async throws
    func remove(item: modelClass)
}

extension PaginatorProtocol {
    
    mutating func insert(_ item: modelClass, at index: Int = 0) {
        items.insert(item, at: index)
    }
    
}

protocol SearchablePaginatorProtocol {
    var filter: JSON? { get }
    func search(_ term: String) async throws
    func clearSearch() async throws
}
