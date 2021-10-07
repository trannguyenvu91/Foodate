//
//  InboxViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 04/10/2021.
//

import UIKit
import CoreStore
import Combine

enum CalendarType: String, CaseIterable {
    case events = "events"
    case inbox = "inbox"
    
    var title: String {
        switch self {
        case .events:
            return NSLocalizedString("CalendarType_Events_Title", comment: "")
        case .inbox:
            return NSLocalizedString("CalendarType_Inbox_Title", comment: "")
        }
    }
}

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
    
    var invitations: [ObjectPublisher<FDInvitation>] {
        items.map({ $0.asPublisher(in: .defaultStack) })
    }
    
    override init() {
        guard let userID = AppConfig.shared.sessionUser?.id else { fatalError("Session user must not be nil!") }
        eventsPaginator = InvitationPaginator.paginator(userID: userID, type: .events)
        inboxPaginator = InvitationPaginator.paginator(userID: userID, type: .inbox)
    }
    
}
