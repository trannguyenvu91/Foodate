//
//  SearchPlaceModel.swift
//  SearchPlaceModel
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation
import CoreStore

class SearchPlaceModel: BaseViewModel, ListViewModel {
    
    var paginator: Paginator<FDPlace>
    
    override init() {
        self.paginator = SearchPlacePaginator(nil)
        super.init()
        fetchNext()
    }
    
    var places: [ObjectPublisher<FDPlace>] {
        items.map({ $0.asPublisher(in: .defaultStack) })
    }
}
