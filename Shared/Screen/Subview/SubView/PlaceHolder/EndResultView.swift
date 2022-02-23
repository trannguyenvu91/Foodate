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
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text("EndResultView_Title".localized())
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
        }
        .foregroundColor(.lightGray)
        .padding()
    }
}

struct EndResultView_Previews: PreviewProvider {
    static var previews: some View {
        EndResultView()
    }
}
