//
//  PlaceHeader.swift
//  Foodate
//
//  Created by Vu Tran on 23/07/2021.
//

import SwiftUI
import CoreStore

struct PlaceHeader: View {
    
    var place: ObjectPublisher<FDPlace>
    var height: CGFloat = 100
    
    init(_ place: ObjectPublisher<FDPlace>) {
        self.place = place
    }
    
    var body: some View {
        NavigationButton(destination: LazyView(PlaceProfileView(place))) {
            ObjectReader(place) { snapshot in
                HStack {
                    infoView(snapshot)
                        .padding(12)
                    Spacer()
                    placeImageView(snapshot)
                }
                .height(self.height)
                .background(Color.placeBackground)
                .cornerRadius(18)
            }
        }
    }
    
    func infoView(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(snapshot.categoryText + " \(String.dotText) " + snapshot.distanceText)
                .font(.subheadline)
            Text(snapshot.$name ?? "--")
                .fontWeight(.semibold)
                .foregroundColor(.black)
            RateHeader(snapshot.$rating ?? 5, totalRatings: nil)
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
            .onAppear {
                ASRemoteImageManager.shared.load(path: snapshot.avatarURL)
        }
    }
    
}

struct PlaceHeader_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHeader(PreviewResource.shared.loadPlace())
    }
}
