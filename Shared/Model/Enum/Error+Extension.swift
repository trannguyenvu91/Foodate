//
//  Error.swift
//  Foodate
//
//  Created by Vu Tran on 12/28/21.
//

import Foundation


enum AppError: Error {
    case unknown
    case fileNotFound
    case invalidJsonFormatted
    case invalidSession
}

enum LocationError: Error {
    case notGranted
    case notAvailable
    
    var alertMessage: String {
        switch self {
        case .notGranted:
            return "Location_Not_Granted".localized()
        case .notAvailable:
            return "Location_Not_Available".localized()
        }
    }
    
}

enum NotificationError: Error {
    case notGranted
    case notAvailable
}
