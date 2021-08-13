//
//  PlaceCell.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import SwiftUI
import CoreStore
import Combine

struct PlaceCell: View {
    
    var place: ObjectPublisher<FDPlace>
    var selectionCommand: PassthroughSubject<Any, Never>?
    
    init(_ place: ObjectPublisher<FDPlace>, selectionCommand: PassthroughSubject<Any, Never>? = nil) {
        self.place = place
        self.selectionCommand = selectionCommand
    }
    
    var height: CGFloat = 110
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let _ = selectionCommand {
                Button {
                    selectionCommand?.send(place)
                } label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                        .foregroundColor(.blue)
                }
                .plainedButton()
            }
            NavigationButton(destination: LazyView(PlaceProfileView(place))) {
                ObjectReader(place) { snapshot in
                    VStack {
                        HStack {
                            infoView(snapshot)
                            Spacer(minLength: 8)
                            placeImageView(snapshot)
                        }
                        .height(self.height)
                    }
                    .padding()
                }
            }
        }
    }
    
    func infoView(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
        VStack(alignment: .leading) {
            Text(snapshot.categoryText + " \(String.dotText) " + snapshot.distanceText)
                .font(.subheadline)
            Text(snapshot.$name ?? "--")
                .fontWeight(.semibold)
                .foregroundColor(.black)
            RateHeader(snapshot.$rating ?? 0, totalRatings: snapshot.$userRatingsTotal ?? 0)
            Text(snapshot.$vicinity ?? "--")
                .fontWeight(.light)
                .font(.footnote)
        }
        .foregroundColor(.gray)
    }
    
    func placeImageView(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
        ASRemoteImageView(path: snapshot.avatarURL)
            .scaledToFill()
            .frame(width: height)
            .height(height)
            .clipped()
            .cornerRadius(18)
            .onAppear {
                ASRemoteImageManager.shared.load(path: snapshot.avatarURL)
        }
    }
    
}

struct PlaceCell_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCell(PreviewResource.shared.loadPlace())
    }
}

