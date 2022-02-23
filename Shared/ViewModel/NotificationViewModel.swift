//
//  NotificationViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation
import Combine

class NotificationViewModel: BaseViewModel, ListViewModel {
    
    var paginator: Paginator<FDNotification> = NotificationPaginator()
    
    func refresh() async {
        asyncDo { [unowned self] in
            try await self.paginator.refresh()
        }
    }
}
