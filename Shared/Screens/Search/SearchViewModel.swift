//
//  SearchViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation
import Combine
import CoreStore

enum SearchType: Int, CaseIterable {
    case invitation = 0
    case account = 1
    case place = 2
    
    var title: String {
        switch self {
        case .account:
            return "Account"
        case .place:
            return "Place"
        case .invitation:
            return "Invitation"
        }
    }
}

class SearchViewModel: BaseViewModel {
    var searchTerm: String = ""
    @Published var selectedIndex = 0
    var tabs: [SearchType]
    
    @Published var userPaginator: Paginator<FDUserProfile>
    @Published var invitationPaginator: Paginator<FDInvitation>
    @Published var placePaginator: Paginator<FDPlace>
    
    var type: SearchType {
        tabs[selectedIndex]
    }
    
    var users: [ObjectPublisher<FDUserProfile>] {
        userPaginator.items.map({ $0.asPublisher(in: .defaultStack)})
    }
    var places: [ObjectPublisher<FDPlace>] {
        placePaginator.items.map({ $0.asPublisher(in: .defaultStack)})
    }
    var invitations: [ObjectPublisher<FDInvitation>] {
        invitationPaginator.items.map({ $0.asPublisher(in: .defaultStack)})
    }
    
    init(_ tabs: [SearchType] = SearchType.allCases) {
        self.tabs = tabs
        self.userPaginator = SearchProfilePaginator(nil)
        self.placePaginator = SearchPlacePaginator(nil)
        self.invitationPaginator = SearchInvitationPaginator(nil)
        super.init()
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
        } catch {
            self.error = error
        }
    }
    
}
