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
    @Published var draft: DraftUserProfile
    
    init(_ snapshot: ObjectSnapshot<FDUserProfile>) {
        self.session = snapshot
        self.draft = DraftUserProfile(session)
        super.init()
    }
    
    func update() async throws {
        let _ = try await LibraryAPI.shared.updateUser(ID: self.session.$id, parameters: self.draft.json)
    }
    
}
