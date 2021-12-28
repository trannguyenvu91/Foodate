//
//  Error.swift
//  ArtBoard
//
//  Created by Vu Tran on 2/21/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

extension Error {
    var alertMessage: String {
        if let error = self as? NetworkError {
            return error.message + " (code: \(error.code))"
        }
        return self.localizedDescription
    }
}
