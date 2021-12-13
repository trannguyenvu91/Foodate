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
