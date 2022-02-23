//
//  ForEach.swift
//  Foodate
//
//  Created by Vu Tran on 09/10/2021.
//

import SwiftUI

extension ForEach where Content: View {

    func placeHolder<PlaceHolder: View>(@ViewBuilder _ builder: @escaping () -> PlaceHolder) -> some View {
        Group {
            if self.data.count == 0 {
                builder()
            } else {
                self
            }
        }
    }
    
}
