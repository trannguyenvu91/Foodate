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
}

enum NotificationError: Error {
    case notGranted
    case notAvailable
}
