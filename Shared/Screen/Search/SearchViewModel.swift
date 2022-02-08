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
    @Published var searchTerm: String = ""
    @Published var selectedIndex = 0
    var tabs: [SearchType]
    
    @Published var userPaginator = SearchProfilePaginator(nil)
    @Published var invitationPaginator = SearchInvitationPaginator(nil)
    @Published var placePaginator = SearchPlacePaginator(nil)
    
    init(_ tabs: [SearchType] = SearchType.allCases) {
        self.tabs = tabs
        super.init()
    }
    
    var type: SearchType {
        tabs[selectedIndex]
    }
    
    var currentPaginator: Searchable & Pagable {
        switch type {
        case .invitation:
            return invitationPaginator
        case .account:
            return userPaginator
        case .place:
            return placePaginator
        }
    }
    
    override func initialSetup() {
        super.initialSetup()
        observeNewInvitation()
        bindSearchText()
    }
    
    func refresh() async {
        do {
            try await currentPaginator.refresh()
        } catch {
            self.error = error
        }
    }
    
    func bindSearchText() {
        $searchTerm.debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [unowned self] text in
                self.search(text)
            }
            .store(in: &cancelableSet)
        $selectedIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                if let self = self,
                    let search = self.currentPaginator.filter?[self.type.searchJSONKey] as? String,
                    search == self.searchTerm {
                    return
                }
                self?.search(self!.searchTerm)
            }
            .store(in: &cancelableSet)
    }
    
    func search(_ text: String) {
        guard !text.isEmpty else {
            currentPaginator.clearSearch()
            return
        }
        asyncDo { [weak self] in
            try await self?.currentPaginator.search([self!.type.searchJSONKey: text])
        }
    }
    
}

extension SearchViewModel: InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> {
        get {
            invitationPaginator
        }
        set {
            invitationPaginator = newValue as! SearchInvitationPaginator
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

internal extension SearchType {
    var searchJSONKey: String {
        switch self {
        case .invitation:
            return "title__unaccent__icontains"
        case .account:
            return "username__unaccent__icontains"
        case .place:
            return "name__unaccent__icontains"
        }
    }
}
