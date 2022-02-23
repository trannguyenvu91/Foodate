//
//  Error.swift
//  ArtBoard
//
//  Created by Vu Tran on 2/21/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

protocol MessageError {
    var message: String { get }
}

extension Error {
    var alertMessage: String {
        if let error = self as? MessageError {
            return error.message
        }
        return localizedDescription
    }
}

extension NetworkError: MessageError {
    
    var message: String {
        switch self {
        case .invalidAPI(let api):
            return "AppError_InvalidAPI".localized() + (api ?? "--")
        case .invalidStatusCode(let code, let message):
            return message + " code: \(code)"
        case .invalidJSONFormat:
            return "AppError_InvalidJSONFormat".localized()
        }
    }
    
}

extension LocationError: MessageError {
    
    var message: String {
        switch self {
        case .notGranted:
            return "Location_Not_Granted".localized()
        case .notAvailable:
            return "Location_Not_Available".localized()
        }
    }
    
}

extension NotificationError: MessageError {
    
    var message: String {
        switch self {
        case .notGranted:
            return "Notification_Not_Granted".localized()
        case .notAvailable:
            return "Notification_Not_Available".localized()
        }
    }
    
}

extension AppError: MessageError {
    var message: String {
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

extension DraftInvitationError: MessageError {
    var message: String {
        switch self {
        case .emptyPlace:
            return "DraftInvitation_Empty_Place_Alert".localized()
        case .invalidTime:
            return "DraftInvitation_Invalid_Time_Alert".localized()
        case .invalidRecipient:
            return "DraftInvitation_Recipient_Alert".localized()
        case .emptyTitle:
            return "DraftInvitation_Empty_Title_Alert".localized()
        }
    }
}
