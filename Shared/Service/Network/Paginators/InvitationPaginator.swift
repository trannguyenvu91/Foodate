//
//  InvitationPaginator.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import UIKit

class InvitationPaginator: Paginator<FDInvitation> {
}

extension InvitationPaginator {
    convenience init(placeID: String) {
        let url = NetworkConfig.baseURL + "/api/v1/places/\(placeID)/invitations/"
        let page = NetworkPage<FDInvitation>(nextURL: url)
        self.init(page)
    }
    
    convenience init(userID: Int, type: CalendarType) {
        let url = NetworkConfig.baseURL + "/api/v1/users/\(userID)/invitations/"
        let page = NetworkPage<FDInvitation>(nextURL: url, params: ["type": type.rawValue])
        self.init(page)
    }
}
