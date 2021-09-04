//
//  UserCell.swift
//  UserCell
//
//  Created by Vu Tran on 29/07/2021.
//

import SwiftUI
import CoreStore
import Combine

struct UserCell: View {
    
    var user: ObjectPublisher<FDUserProfile>
    var selectionCommand: PassthroughSubject<Any, Never>?
    
    init(_ user: ObjectPublisher<FDUserProfile>, selectionCommand: PassthroughSubject<Any, Never>? = nil) {
        self.user = user
        self.selectionCommand = selectionCommand
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let _ = selectionCommand {
                Button {
                    selectionCommand?.send(user)
                } label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                        .foregroundColor(.blue)
                }
                .plainedButton()
            }
            NavigationButton(destination: LazyView(UserProfileView(user))) {
                ObjectReader(user) { snapshot in
                    VStack(alignment: .leading) {
                        photosView(snapshot)
                        infoView(snapshot)
                    }
                }
                .padding([.top, .bottom])
            }
        }
    }
    
    func photosView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(snapshot.$photos, id: \.self) { photo in
                    let baseURL = photo.asSnapshot(in: .defaultStack)!.$baseURL
                    ASRemoteImageView(path: baseURL)
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipped()
                        .cornerRadius(18)
                        .onAppear {
                            ASRemoteImageManager.shared.load(path: baseURL!)
                    }
                }
            }
            .padding(.leading)
        }
    }
    
    func infoView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(snapshot.name)
                    .fontWeight(.medium)
                Text("\(snapshot.age ?? 0)t")
                Text(" \(String.dotText) \(snapshot.$location?.distanceFromCurrent ?? "--")")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            Text(snapshot.$bio ?? "--")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding([.leading, .trailing])
    }
    
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        let profile: ObjectPublisher<FDUserProfile> = PreviewResource.shared.loadUser()
        UserCell(profile)
    }
}
