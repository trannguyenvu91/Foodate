//
//  SearchViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation
import Combine

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
    
    @Published var userSearch = SearchUserModel()
    @Published var placeSearch = SearchPlaceModel()
    @Published var invitationSearch = SearchInvitationModel()
    
    var type: SearchType {
        tabs[selectedIndex]
    }
    
    init(_ tabs: [SearchType] = SearchType.allCases) {
        self.tabs = tabs
        super.init()
        bindSearchModels()
    }
    
    func bindSearchModels() {
        userSearch.objectWillChange
            .merge(with: placeSearch.objectWillChange, invitationSearch.objectWillChange)
            .sink { [weak self] search in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancelableSet)
    }
    
}
