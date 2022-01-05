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
    
    @Published var eventsPaginator: Paginator<FDInvitation>
    @Published var inboxPaginator: Paginator<FDInvitation>
    @Published var selectedTab = CalendarType.events
    var paginator: Paginator<FDInvitation> {
        switch selectedTab {
        case .events:
            return eventsPaginator
        case .inbox:
            return inboxPaginator
        }
    }
    
    override init() {
        guard let userID = AppConfig.shared.sessionUser?.id else {
            fatalError("Session user must not be nil!")
        }
        eventsPaginator = InvitationPaginator.paginator(userID: userID, type: .events)
        inboxPaginator = InvitationPaginator.paginator(userID: userID, type: .inbox)
    }
    
}
