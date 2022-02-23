//
//  Error.swift
//  ArtBoard
//
//  Created by Vu Tran on 2/21/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

extension Error where Self == NetworkError {
    var localizedDescription: String {
        switch self {
        case .invalidAPI(let api):
            return "AppError_InvalidAPI".localized() + (api ?? "--")
        case .invalidStatusCode(let code, let message):
            return message + "\(code)"
        case .invalidJSONFormat:
            return "AppError_InvalidJSONFormat".localized()
        }
    }
}

extension Error where Self == LocationError {
    
    var localizeDescription: String {
        switch self {
        case .notGranted:
            return "Location_Not_Granted".localized()
        case .notAvailable:
            return "Location_Not_Available".localized()
        }
    }
    
}

extension Error where Self == NotificationError {
    
    var localizeDescription: String {
        switch self {
        case .notGranted:
            return "Notification_Not_Granted".localized()
        case .notAvailable:
            return "Notification_Not_Available".localized()
        }
    }
    
}

extension Error where Self == AppError {
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "AppError_Unknown".localized()
        case .fileNotFound:
            return "AppError_FileNotFound".localized()
        case .invalidJsonFormatted:
            return "AppError_InvalidJSONFormat".localized()
        case .invalidSession:
            return "AppError_InvalidSession".localized()
        }
    }
}
