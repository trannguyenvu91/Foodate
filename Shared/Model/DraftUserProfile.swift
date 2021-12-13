//
//  DraftUserProfile.swift
//  Foodate
//
//  Created by Vu Tran on 03/09/2021.
//

import Foundation
import CoreStore

struct DraftUserProfile {
    
    @Capitalized var firstName = ""
    @Capitalized var lastName = ""
    var job = ""
    
    @LinebreakRemoved var userName = ""
    var bio = ""
    @Lowercased var email = ""
    var birthday = Date()
    
    init(_ profile: ObjectSnapshot<FDUserProfile>) {
        self.firstName = profile.$firstName ?? ""
        self.lastName = profile.$lastName ?? ""
        self.userName = profile.$userName ?? ""
        self.bio = profile.$bio ?? ""
        self.email = profile.$email ?? ""
        self.birthday = profile.$birthday ?? Date()
        self.job = profile.$job ?? ""
    }
    
    var json: JSON {
        [
            "first_name": firstName,
            "last_name": lastName,
            "job": job,
            "username": userName.lowercased(),
            "bio": bio,
            "email": email,
            "birthday": DateFormatter.standard.string(from: birthday)
        ]
    }
}
