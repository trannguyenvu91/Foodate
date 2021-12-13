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
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text("EmptyResultView_Title".localized())
                .font(.callout)
                .fontWeight(.semibold)
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
