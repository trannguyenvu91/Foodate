//
//  Bundle.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation

extension Bundle {
    
    func json(forResource: String, ofType: String) -> JSON? {
        guard let path = path(forResource: forResource, ofType: ofType) else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
        } catch {
            return nil
        }
    }
    
}
