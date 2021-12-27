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
    
    var userPaginator: Paginator<FDUserProfile>
    var invitationPaginator: Paginator<FDInvitation>
    var placePaginator: Paginator<FDPlace>
    
    var type: SearchType {
        tabs[selectedIndex]
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
            objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}
