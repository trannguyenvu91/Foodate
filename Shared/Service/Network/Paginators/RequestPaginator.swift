//
//  RequestPaginator.swift
//  Foodate
//
//  Created by Vu Tran on 03/08/2021.
//

import UIKit

class RequestPaginator: Paginator<FDRequester> {
    
    convenience init(_ invitationID: Int) {
        let url = NetworkConfig.baseURL + "/api/v1/invitations/\(invitationID)/requests/"
        let page = NetworkPage<FDRequester>(nextURL: url, results: nil)
        self.init(page)
    }
    
}
