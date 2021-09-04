//
//  Color.swift
//  JustDate
//
//  Created by Vu Tran on 6/15/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import SwiftUI


extension Color {
    
    // invitation
    static var openInvitation: Color {
        Color(hex: 0x1FC1DB)
    }
    static var directInvitation: Color {
        Color(hex: 0x8183F6)
    }
    static var matched: Color {
        Color(hex: 0x00C653)
    }
    static var rejected: Color {
        Color(hex: 0xEE1247, alpha: 0.3)
    }
    static var archived: Color {
        Color(hex: 0x14BFAD)
    }
    static var canceled: Color {
        Color(hex: 0xf3e8d2)
    }
    
    //MARK:
    static var placeBackground: Color {
        Color(hex: 0xF0F2F5)
    }
    static var lightGray: Color {
        Color(hex: 0xD3D3D3)
    }
    static var groupTableViewBackground: Color {
        Color(hex: 0xEFEFF4)
    }
    
}

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}
