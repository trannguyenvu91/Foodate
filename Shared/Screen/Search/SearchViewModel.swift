//
//  SearchViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation
import Combine
import CoreStore

class SearchViewModel: BaseViewModel {
    var searchTerm: String = ""
    @Published var selectedIndex = 0
    var tabs: [SearchType]
    
    var userPaginator: Paginator<FDUserProfile> = SearchProfilePaginator(nil)
    var invitationPaginator: Paginator<FDInvitation> = SearchInvitationPaginator(nil)
    var placePaginator: Paginator<FDPlace> = SearchPlacePaginator(nil)
    
    var type: SearchType {
        tabs[selectedIndex]
    }
    
    init(_ tabs: [SearchType] = SearchType.allCases) {
        self.tabs = tabs
        super.init()
    }
    
    override func initialSetup() {
        super.initialSetup()
        observeNewInvitation()
    }
    
    func refresh() async {
        do {
            switch type {
            case .invitation:
                try await invitationPaginator.refresh()
            case .account:
                try await userPaginator.refresh()
            case .place:
                try await placePaginator.refresh()
            }
            objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}

extension SearchViewModel: InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> {
        get {
            invitationPaginator
        }
        set {
            invitationPaginator = newValue
        }
    }
    
    func shouldInsert(_ invitation: FDInvitation) -> Bool {
        guard let snapshot = invitation.asSnapshot(in: .defaultStack) else {
            return false
        }
        if snapshot.$owner?.isSession == true {
            return true
        }
        return false
    }
    
}
