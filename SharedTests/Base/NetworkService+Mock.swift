//
//  MockResouces.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 1/10/22.
//

import CoreStore
import Foundation
import Foodate
import Alamofire

class MockNetworkActor: ServiceActor {
    
    static var responseCase: MockResponse = .invitation
    
    func request(url: String, method: HTTPMethod, parameters: JSON?, headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
        try Self.responseCase.jsonValue
    }
    
}

enum MockResponse {
    case invitation
    case requester
    case notification
    case place
    case sessionUser
    case notificationPage
    case notificationPageShorten
    case notificationPageShorten2
    case error
    case custom(JSON)
    
    var jsonValue: JSON {
        get throws {
            switch self {
            case .custom(let json):
                return json
            case .error:
                throw NetworkError.invalidJSONFormat
            default:
                return try Bundle(for: MockNetworkActor.self)
                    .json(forResource: jsonFilename, ofType: "json")
            }
        }
    }
    
    var jsonFilename: String {
        get throws {
            switch self {
            case .invitation:
                return "invitation"
            case .requester:
                return "requester"
            case .notification:
                return "notification"
            case .place:
                return "place"
            case .sessionUser:
                return "session_user"
            case .notificationPage:
                return "notification_page"
            case .notificationPageShorten:
                return "notification_page_shorten"
            case .notificationPageShorten2:
                return "notification_page_shorten_2"
            case .error, .custom(_):
                throw AppError.fileNotFound
            }
        }
    }
    
}
