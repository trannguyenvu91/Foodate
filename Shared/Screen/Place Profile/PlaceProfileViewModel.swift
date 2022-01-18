//
//  PlaceProfileViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import Foundation
import CoreStore

class PlaceProfileViewModel: BaseObjectViewModel<FDPlace>, ListViewModel {
    
    lazy var paginator: Paginator<FDInvitation> = {
        InvitationPaginator(placeID: objectID)
    }()
    
    override func initialSetup() {
        super.initialSetup()
        observeNewInvitation()
    }
    
    func refresh() async {
        do {
            try await loadObject()
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}

extension PlaceProfileViewModel: InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> {
        get {
            paginator
        }
        set {
            paginator = newValue
        }
    }
    
    func shouldInsert(_ invitation: FDInvitation) -> Bool {
        guard let snapshot = invitation.asSnapshot(in: .defaultStack) else {
            return false
        }
        return snapshot.$place?.asSnapshot(in: .defaultStack)?.$id == objectID
    }
    
}
