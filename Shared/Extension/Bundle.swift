//
//  Bundle.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation

extension Bundle {
    
    func json(forResource: String, ofType: String) throws -> JSON {
        guard let path = path(forResource: forResource, ofType: ofType) else {
            throw AppError.fileNotFound
        }
        let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else {
            throw AppError.invalidJsonFormatted
        }
        return json
    }
    
}
