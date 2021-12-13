//
//  EndResultView.swift
//  Foodate
//
//  Created by Vu Tran on 12/10/21.
//

import SwiftUI

struct EndResultView: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "eyeglasses")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text("EndResultView_Title".localized())
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
        }
        .foregroundColor(.lightGray)
    }
}

struct EndResultView_Previews: PreviewProvider {
    static var previews: some View {
        EndResultView()
    }
}
