//
//  InboxViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 04/10/2021.
//

import Foundation
import CoreStore
import Combine

class CalendarViewModel: BaseViewModel, ListViewModel {
    
    @Published var eventsPaginator: Paginator<FDInvitation> = InvitationPaginator(userID: try! sessionUserID, type: .events)
    @Published var inboxPaginator = InvitationPaginator(userID: try! sessionUserID, type: .inbox)
    @Published var selectedTab = CalendarType.events
    
    override func initialSetup() {
        super.initialSetup()
        observeNewInvitation()
    }
    
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
            guard let userID = AppSession.shared.sessionUser?.id else {
                throw AppError.invalidSession
            }
            return userID
        }
    }
    
}

extension CalendarViewModel: InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> {
        get {
            eventsPaginator
        }
        set {
            eventsPaginator = newValue
        }
    }
    
    func shouldInsert(_ invitation: FDInvitation) -> Bool {
        guard let snapshot = invitation.asSnapshot(in: .defaultStack) else {
            return false
        }
        if snapshot.$owner?.isSession == true {
            return true
        } else if snapshot.$toUser?.isSession == true, snapshot.$state == .matched {
            return true
        }
        return false
    }
    
}
