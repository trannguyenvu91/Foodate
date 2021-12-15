//
//  NotificationPaginator.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation

class NotificationPaginator: Paginator<FDNotification> {
    convenience init() {
        let url = NetworkConfig.baseURL + "/api/v1/notifications/"
        let page = NetworkPage<FDNotification>(nextURL: url, results: nil)
        self.init(page)
    }
}
