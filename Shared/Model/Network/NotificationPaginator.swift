//
//  NotificationPaginator.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation

class NotificationPaginator: Paginator<FDNotification> {
    convenience init() {
        let url = serverBaseURL + "/api/v1/notifications/"
        let page = NetworkPage<FDNotification>(nextURL: url)
        self.init(page)
    }
}
