//
//  Combine.swift
//  ArtBoard
//
//  Created by Vu Tran on 1/2/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Combine
import Foundation

extension Subscribers.Completion {
    
    var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
    
}
