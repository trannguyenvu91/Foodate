//
//  SearchProfilePaginator.swift
//  SearchProfilePaginator
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation

class SearchProfilePaginator: Paginator<FDUserProfile> {
    
    convenience init(_ params: JSON?) {
        let url = NetworkConfig.baseURL + "/api/v1/users/search/"
        let page = NetworkPage<FDUserProfile>(nextURL: url, results: nil)
        self.init(page)
    }
    
}
