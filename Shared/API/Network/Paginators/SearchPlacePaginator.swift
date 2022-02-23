//
//  SearchPlacePaginator.swift
//  SearchPlacePaginator
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation

class SearchPlacePaginator: SearchablePaginator<FDPlace> {
    
    convenience init(_ params: JSON?) {
        let url = serverBaseURL + "/api/v1/places/"
        let page = NetworkPage<FDPlace>(nextURL: url, params: params)
        self.init(page)
    }
    
}
