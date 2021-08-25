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
                self.draft.toUser = user
            } else if let place = object as? ObjectPublisher<FDPlace> {
                self.draft.place = place
            }
        }
        .store(in: &cancelableSet)
    }
    
    func bindCreateCommand() {
        createCommand.sink(receiveValue: { [unowned self] _ in
            let publisher = self.draft.getData()
                .flatMap({ NetworkService.createInvitation(parameters: $0) })
                .eraseToAnyPublisher()
            self.execute(publisher: publisher, success: { (invitation) in
                self.didCreateCommand.send(invitation)
            })
        })
        .store(in: &cancelableSet)
    }
    
}
