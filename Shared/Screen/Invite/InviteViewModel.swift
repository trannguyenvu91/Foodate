//
//  InviteViewModel.swift
//  JustDate
//
//  Created by Vu Tran on 5/18/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation
import Combine
import CoreStore

class InviteViewModel: BaseViewModel, Identifiable {
    
    @Published var draft = DraftInvitation()
    var selectionCommand = PassthroughSubject<Any, Never>()
    
    override init() {
        super.init()
        bindSelectionCommand()
        bind([draft.objectWillChange])
    }
    
    func bindSelectionCommand() {
        selectionCommand.sink { [unowned self] object in
            if let user = object as? ObjectSnapshot<FDUserProfile> {
                self.draft.toUser = user
            } else if let place = object as? ObjectSnapshot<FDPlace> {
                self.draft.place = place
            }
        }
        .store(in: &cancelableSet)
    }
    
    func createInvitation() async throws {
        let invitation = try await NetworkService.createInvitation(parameters: try draft.getData())
        AppSession.shared.newInvitation.send(invitation)
    }
    
}
