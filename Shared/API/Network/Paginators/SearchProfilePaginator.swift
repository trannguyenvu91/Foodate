//
//  SearchProfilePaginator.swift
//  SearchProfilePaginator
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation

class SearchProfilePaginator: SearchablePaginator<FDUserProfile> {
    
    convenience init(_ params: JSON?) {
        let url = serverBaseURL + "/api/v1/users/"
        let page = NetworkPage<FDUserProfile>(nextURL: url, params: params)
        self.init(page)
    }
    
}
