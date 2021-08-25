//
//  UserProfileViewModel.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import Combine
import CoreStore

class UserProfileViewModel: ObjectBaseViewModel<FDUserProfile> {
    
    func refreshProfile() {
        guard let id = objectPubliser.id else {
            return
        }
        execute(publisher: NetworkService.getUser(ID: id))
    }
    
}
