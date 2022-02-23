//
//  EmptyResultView.swift
//  Foodate
//
//  Created by Vu Tran on 12/13/21.
//

import SwiftUI

struct EmptyResultView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image("no-result")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text("EmptyResultView_Title".localized())
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .foregroundColor(.lightGray)
    }
}

struct EmptyResultView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyResultView()
    }
}
