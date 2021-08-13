//
//  SearchInvitationPaginator.swift
//  SearchInvitationPaginator
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation

class SearchInvitationPaginator: Paginator<FDInvitation> {
    
    convenience init(_ params: JSON?) {
        let url = NetworkConfig.baseURL + "/api/v1/invitations/"
        let page = NetworkPage<FDInvitation>(nextURL: url, results: nil)
        self.init(page)
    }
    
}
