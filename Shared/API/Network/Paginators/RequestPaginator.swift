//
//  RequestPaginator.swift
//  Foodate
//
//  Created by Vu Tran on 03/08/2021.
//

import Foundation

class RequestPaginator: Paginator<FDRequester> {
    
    convenience init(_ invitationID: Int) {
        let url = NetworkConfig.baseURL + "/api/v1/invitations/\(invitationID)/requests/"
        let page = NetworkPage<FDRequester>(nextURL: url)
        self.init(page)
    }
    
}
