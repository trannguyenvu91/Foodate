//
//  MatchedView.swift
//  Foodate
//
//  Created by Vu Tran on 1/6/22.
//

import SwiftUI

struct MatchedView: View {
    var body: some View {
        List {
            page
        }
    }
    
    @ViewBuilder
    var page: some View {
        Text("Matched")
        ForEach(0..<1000) { index in
            Text("\(index)")
                .onAppear {
                    print(index)
                }
        }
    }
    
}

struct MatchedView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedView()
    }
}
