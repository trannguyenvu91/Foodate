//
//  String.swift
//  JustDate
//
//  Created by Vu Tran on 6/16/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

extension String {
    
    static var dotText: String {
        return "•"
    }
    
    var hexadecimal: Data {
        get throws {
            if count % 2 != 0 {
                throw AppError.unknown
            }
            let length = 2
            let end = count/length
            let range = 0..<end
            let transformHex: (Int) -> String = {
                String(dropFirst($0 * length).prefix(length))
            }
            let transformByte: (String) throws -> UInt8 = {
                guard let value = UInt8($0, radix: 16) else {
                    throw AppError.unknown
                }
                return value
            }
            let bytes = try range.map(transformHex).map(transformByte)
            return Data(bytes)
        }
    }
}
