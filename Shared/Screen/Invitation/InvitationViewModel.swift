//
//  InvitationViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 12/22/21.
//

import Foundation
import Combine
import CoreStore

class InvitationViewModel: BaseViewModel {
    
    var invitationID: Int
    @Published var invitation: ObjectPublisher<FDInvitation>? {
        willSet {
            invitation?.removeObserver(self)
        }
        didSet {
            invitation?.addObserver(self, { [unowned self] _ in
                self.objectWillChange.send()
            })
        }
    }
    var paginator: Paginator<FDRequester>
    
    init(_ invitationID: Int) {
        self.paginator = RequestPaginator(invitationID)
        self.invitationID = invitationID
        super.init()
    }
    
    func accept(_ requester: ObjectSnapshot<FDRequester>) async throws {
        let invitation = try await NetworkService.acceptRequest(for: invitationID,
                                                          requestID: requester.$requestID)
        viewDismissalModePublisher.send(true)
        if let snapshot = invitation.asSnapshot(in: .defaultStack) {
            AppConfig.shared.presentScreen = .matched(snapshot)
        }
    }
    
    var snapshot: ObjectSnapshot<FDInvitation>? {
        invitation?.asSnapshot(in: .defaultStack)
    }
    
    var canViewRequests: Bool {
        snapshot?.$owner?.asSnapshot(in: .defaultStack)?.isSession == true &&
        snapshot?.$state == .pending
    }
    
    var isArchivedInvitation: Bool {
        if let endAt = snapshot?.$endAt, endAt < Date.now {
            return true
        }
        return false
    }
    
    func refresh() async {
        do {
            try await getInvitation()
            if canViewRequests {
                try await paginator.refresh()
            }
        } catch {
            self.error = error
        }
    }
    
    func getInvitation() async throws {
        invitation = try FDCoreStore.shared.fetchOne(
            Where<FDInvitation>("id == \(invitationID)")
        )?.asPublisher(in: .defaultStack)
        invitation = try await NetworkService.getInvitation(ID: invitationID).asPublisher(in: .defaultStack)
    }
    
    deinit {
        invitation?.removeObserver(self)
    }
    
}
