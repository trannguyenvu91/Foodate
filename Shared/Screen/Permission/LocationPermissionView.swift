//
//  LocationPermissionView.swift
//  Foodate
//
//  Created by Vu Tran on 12/28/21.
//

import SwiftUI

struct LocationPermissionView: View {
    @State var error: Error? {
        didSet {
            isPresentingError = error != nil
        }
    }
    @State var isPresentingError = false
    
    var body: some View {
        VStack {
            Image("location-permission")
                .resizable()
                .scaledToFit()
                .width(300)
            Text("LocationView_Title".localized())
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.cyan)
            Text("LocationView_SubTitle".localized())
                .font(.title2)
                .padding([.leading, .trailing], 30)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
                .foregroundColor(.gray)
            AsyncButton(task: {
                try await AppConfig.shared.updateUserLocation()
            }, error: $error) {
                Text("LocationView_AllowButton".localized())
                    .fontWeight(.semibold)
                    .padding([.leading, .trailing], 50)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.blue)
            .controlSize(.large)
            .padding(.top, 40)
            .foregroundColor(.white)
            Button {
                
            } label: {
                Text("LocationView_SkipButton".localized())
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.top, 4)
        }
        .presentAlert(error: error, isPresented: $isPresentingError)
    }
    
}

struct LocationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPermissionView()
    }
}
