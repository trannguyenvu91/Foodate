//
//  EditProfileViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 13/08/2021.
//

import Foundation
import Combine
import CoreStore

class EditProfileViewModel: BaseViewModel {
    
    var session: ObjectSnapshot<FDUserProfile>
    var updateCommand = PassthroughSubject<Any?, Never>()
    var didUpdateProfile = PassthroughSubject<Bool, Never>()
    @Published var draft: DraftUserProfile
    
    init(_ snapshot: ObjectSnapshot<FDUserProfile>) {
        self.session = snapshot
        self.draft = DraftUserProfile(session)
        super.init()
        bindUpdate()
    }
    
    func bindUpdate() {
        updateCommand.sink { [unowned self] _ in
            execute(publisher: NetworkService.updateUser(ID: session.$id, parameters: draft.json), success: { _ in
                didUpdateProfile.send(true)
            })
        }.store(in: &cancelableSet)
    }
    
}
