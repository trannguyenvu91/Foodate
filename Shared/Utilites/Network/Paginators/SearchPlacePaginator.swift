//
//  SearchPlacePaginator.swift
//  SearchPlacePaginator
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation

class SearchPlacePaginator: Paginator<FDPlace> {
    
    convenience init(_ params: JSON?) {
        let url = NetworkConfig.baseURL + "/api/v1/places/"
        let page = NetworkPage<FDPlace>(nextURL: url, results: nil)
        self.init(page)
    }
    
}
