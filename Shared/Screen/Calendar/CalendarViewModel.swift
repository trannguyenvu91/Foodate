//
//  InboxViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 04/10/2021.
//

import UIKit
import CoreStore
import Combine

class CalendarViewModel: BaseViewModel, ListViewModel {
    
    @Published var eventsPaginator = InvitationPaginator(userID: try! sessionUserID, type: .events)
    @Published var inboxPaginator = InvitationPaginator(userID: try! sessionUserID, type: .inbox)
    @Published var selectedTab = CalendarType.events
    
    var paginator: Paginator<FDInvitation> {
        switch selectedTab {
        case .events:
            return eventsPaginator
        case .inbox:
            return inboxPaginator
        }
    }
    
    static var sessionUserID: Int {
        get throws {
            guard let userID = AppConfig.shared.sessionUser?.id else {
                throw AppError.invalidSession
            }
            return userID
        }
    }
    
}
