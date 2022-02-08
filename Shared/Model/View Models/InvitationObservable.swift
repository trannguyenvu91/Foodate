//
//  InvitationObservable.swift
//  Foodate
//
//  Created by Vu Tran on 1/18/22.
//

import Foundation
import CoreStore

protocol InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> { get }
    func shouldInsert(_ invitation: FDInvitation) -> Bool
}

extension InvitationObservable where Self: BaseViewModel {
    
    func observeNewInvitation() {
        AppSession.shared.newInvitation
            .receive(on: RunLoop.main)
            .sink { [weak self] invitation in
                guard self?.shouldInsert(invitation) == true,
                self?.observedPaginator
                    .items.asSnapshots()
                    .map(\.$id)
                    .contains(invitation.asSnapshot(in: .defaultStack)?.$id ?? 0) == false else {
                    return
                }
                self?.observedPaginator.insert(invitation)
                self?.objectWillChange.send()
            }.store(in: &cancelableSet)
    }
    
}
