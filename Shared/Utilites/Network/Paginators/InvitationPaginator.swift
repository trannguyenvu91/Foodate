//
//  InvitationPaginator.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import UIKit

class InvitationPaginator: Paginator<FDInvitation> {
    
    convenience init(_ api: String) {
        let url = NetworkConfig.baseURL + api
        let page = NetworkPage<FDInvitation>(nextURL: url, results: nil)
        self.init(page)
    }
    
}

extension InvitationPaginator {
    class func paginator(placeID: String) -> InvitationPaginator {
        InvitationPaginator("api/v1/places/\(placeID)/invitations/")
    }
    class func paginator(userID: Int) -> InvitationPaginator {
        InvitationPaginator("api/v1/users/\(userID)/invitations/")
    }
    
}
