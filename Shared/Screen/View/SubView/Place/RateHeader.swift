//
//  RateHeader.swift
//  JustDate
//
//  Created by Vu Tran on 5/13/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import SwiftUI

struct RateHeader: View {
    
    var value: Int
    var totalRatings: Int?
    
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 0) {
                if value > 0 {
                    ForEach(0..<value, id: \.self) { _ in
                        self.starView.foregroundColor(.yellow)
                    }
                }
                if value < 5 {
                    ForEach(value..<5, id: \.self) { _ in
                        self.starView.foregroundColor(.gray)
                    }
                }
            }
            if let count = totalRatings {
                Text("(\(count))")
            }
        }
        .foregroundColor(.gray)
        .font(.subheadline)
    }
    
    var starView: some View {
        Image(systemName: "star.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
    }
    
}

extension RateHeader {
    
    init(_ rating: Double, totalRatings: Int?) {
        self.value = Int(round(rating))
        self.totalRatings = totalRatings
    }
    
}

struct RateCell_Previews: PreviewProvider {
    static var previews: some View {
        RateHeader(4.6, totalRatings: 67)
    }
}
