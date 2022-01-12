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

enum MockResponse: String {
    case inivitation = "invitation"
    case requester = "requester"
    case notification = "notification"
    case place = "place"
    case sessionUser = "session_user"
    case notificationPage = "notification_page"
    case error = "error"
    
    var jsonValue: JSON {
        get throws {
            if self == .error {
                throw NetworkError.invalidJSONFormat
            }
            return Bundle(for: MockNetworkService.self)
                .json(forResource: rawValue, ofType: "json") ?? [:]
        }
    }
    
}
