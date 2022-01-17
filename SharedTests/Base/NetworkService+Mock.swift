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

class MockNetworkService: NetworkService {
    
    static var responseCase: MockResponse = .inivitation
    
    override func request(url: String, method: HTTPMethod, parameters: JSON?, headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
        try Self.responseCase.jsonValue
    }
    
}

enum MockResponse {
    case inivitation
    case requester
    case notification
    case place
    case sessionUser
    case notificationPage
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
                return try Bundle(for: MockNetworkService.self)
                    .json(forResource: jsonFilename, ofType: "json")
            }
        }
    }
    
    var jsonFilename: String {
        get throws {
            switch self {
            case .inivitation:
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
            case .error, .custom(_):
                throw AppError.fileNotFound
            }
        }
    }
    
}
