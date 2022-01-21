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
    
    var userPaginator: SearchablePaginator<FDUserProfile> = SearchProfilePaginator(nil)
    var invitationPaginator: SearchablePaginator<FDInvitation> = SearchInvitationPaginator(nil)
    var placePaginator: SearchablePaginator<FDPlace> = SearchPlacePaginator(nil)
    
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
        bindSearchText()
    }
    
    func refresh() async {
        guard searchTerm.isEmpty else {
            await search(searchTerm)
            return
        }
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
    
    func bindSearchText() {
        $searchTerm.debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [unowned self] text in
                guard !text.isEmpty else {
                    self.clearSearch()
                    return
                }
                Task {
                    await self.search(text)
                }
            }
            .store(in: &cancelableSet)
    }
    
    func search(_ text: String) async {
        do {
            switch type {
            case .invitation:
                try await invitationPaginator.search(["title__unaccent__icontains": text])
            case .account:
                try await userPaginator.search(["username__unaccent__icontains": text])
            case .place:
                try await placePaginator.search(["name__unaccent__icontains": text])
            }
        } catch {
            self.error = error
        }
    }
    
    func clearSearch() {
        switch type {
        case .invitation:
            invitationPaginator.clearSearch()
        case .account:
            userPaginator.clearSearch()
        case .place:
            placePaginator.clearSearch()
        }
    }
    
}

extension SearchViewModel: InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> {
        get {
            invitationPaginator
        }
        set {
            invitationPaginator = newValue as! SearchablePaginator<FDInvitation>
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
