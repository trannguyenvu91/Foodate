//
//  InviteViewModel.swift
//  JustDate
//
//  Created by Vu Tran on 5/18/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import UIKit
import Combine
import CoreStore

class InviteViewModel: BaseViewModel, Identifiable {
    
    @Published var draft = DraftInvitation()
    var selectionCommand = PassthroughSubject<Any, Never>()
    var createCommand = PassthroughSubject<Any?, Never>()
    var didCreateCommand = PassthroughSubject<Any?, Never>()
    
    override init() {
        super.init()
        bindSelectionCommand()
        bindCreateCommand()
        bind([draft.objectWillChange])
    }
    
    func bindSelectionCommand() {
        selectionCommand.sink { [unowned self] object in
            if let user = object as? ObjectPublisher<FDUserProfile> {
                self.draft.toUser = user.asSnapshot(in: .defaultStack)
            } else if let place = object as? ObjectPublisher<FDPlace> {
                self.draft.place = place.asSnapshot(in: .defaultStack)
            }
        }
        .store(in: &cancelableSet)
    }
    
    func bindCreateCommand() {
        createCommand
            .sink { [unowned self] _ in
                asyncDo {
                    let invitation = try await NetworkService.createInvitation(parameters: try draft.getData())
                    didCreateCommand.send(invitation)
                }
            }
            .store(in: &cancelableSet)
    }
    
}
