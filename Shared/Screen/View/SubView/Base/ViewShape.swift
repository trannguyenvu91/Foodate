//
//  StadiumShape.swift
//  Foodate
//
//  Created by Vu Tran on 09/09/2021.
//

import SwiftUI

struct StadiumShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path(roundedRect: rect, cornerRadius: rect.height / 2, style: .circular)
    }
    
}

extension Shape where Self == StadiumShape {
    static var stadium: Self {
        StadiumShape()
    }
}

struct RoundedShape: Shape {
    
    var corners: UIRectCorner = .allCorners
    var radius: CGFloat = 8
    
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: .init(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

extension Shape where Self == RoundedShape {
    static func rounded(_ corners: UIRectCorner = .allCorners, radius: CGFloat = 8) -> RoundedShape {
        RoundedShape(corners: corners, radius: radius)
    }
}
