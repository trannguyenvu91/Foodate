//
//  SearchInvitationPaginator.swift
//  SearchInvitationPaginator
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation

class SearchInvitationPaginator: SearchablePaginator<FDInvitation> {
    
    convenience init(_ params: JSON?) {
        let url = serverBaseURL + "/api/v1/invitations/"
        let page = NetworkPage<FDInvitation>(nextURL: url, params: params)
        self.init(page)
    }
    
}
