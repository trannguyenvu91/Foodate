//
//  PaginatorProtocol.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import Combine

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
    var isCanceled: Bool { get set }
    var isFetching: Bool { get }
    var items: [modelClass] { get set }
    
    func fetchNextPage(completion: CompletionBlock?, failure: FailureBlock?)
    func refresh(completion: CompletionBlock?, failure: FailureBlock?)
    func reset()
    func remove(item: modelClass)
}
