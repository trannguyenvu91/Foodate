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

protocol LocalResourceProtocol: ImportableJSONObject {
    static var localSamplePath: (String, String) { get }
}

extension LocalResourceProtocol {
    static func stub() -> Self {
        let (source, type) = localSamplePath
        return PreviewResource.test.loadObject(source: source, type: type)
    }
}

struct MockResource<Result>: ResourceProtocol where Result: LocalResourceProtocol {
    
    init(method: HTTPMethod, params: JSON?, api: String) {}
    
    func request() async throws -> Result {
        Result.stub()
    }
    
}
