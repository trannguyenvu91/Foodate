//
//  FDSessionUser.swift
//  FDSessionUser
//
//  Created by Vu Tran on 25/07/2021.
//

import Foundation
import CoreStore
import CoreLocation

extension ObjectSnapshot where O: FDSessionUser {
    func update(location: CLLocation) async throws {
        let _ = try await NetworkService.updateUser(ID: self.$id,
                                                    parameters: ["location": FDLocation(location).toString])
    }
}
