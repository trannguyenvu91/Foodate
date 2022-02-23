//
//  ErrorView.swift
//  Foodate
//
//  Created by Vu Tran on 12/27/21.
//

import SwiftUI

struct ErrorView: View {
    
    var error: Error
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "exclamationmark.icloud")
                    .resizable()
                    .scaledToFit()
                    .width(40)
                Text(error.alertMessage)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.top, .bottom], 30)
            Spacer()
        }
        .foregroundColor(.lightGray)
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NetworkError.invalidJSONFormat)
    }
}
