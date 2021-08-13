//
//  Codable.swift
//  JustDate
//
//  Created by Vu Tran on 7/3/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

protocol Copiable: Codable {
    
}

extension Copiable {
    
    func toJSON() throws -> JSON {
        let data = try NetworkService.encoder.encode(self)
        return try JSONSerialization.jsonObject(with: data, options: []) as! JSON
    }
    
    var makeCopy: Self? {
        do {
            let data = try NetworkService.encoder.encode(self)
            let draft = try NetworkService.decoder.decode(Self.self, from: data)
            return draft
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
    
}
