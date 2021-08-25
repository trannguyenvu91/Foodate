//
//  PlaceProfileView.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import SwiftUI
import CoreStore

struct PlaceProfileView: View {
    
    @ObservedObject var model: PlaceProfileViewModel
    
    init(_ publisher: ObjectPublisher<FDPlace>) {
        model = PlaceProfileViewModel(publisher)
    }
    
    var body: some View {
        GeometryReader { proxy in
            List {
                ObjectReader(model.objectPubliser) { snapshot in
                    PhotosPageView(snapshot.$photos)
                        .listRowInsets(EdgeInsets())
                        .frame(width: proxy.size.width, height: proxy.size.width)
                        .navigationTitle(snapshot.$name ?? "Địa điểm")
                    placeInfoView(snapshot)
                }
                BulletinBoardView(model.invitations, showPlace: false)
                    .ignoresSafeArea()
                    .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            model.refreshProfile()
            model.fetchNext()
        }
        .bindErrorAlert(to: $model)
    }
    
    func placeInfoView(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(snapshot.$name ?? "--")
                    .font(.title)
                Text(String.dotText + " " + snapshot.distanceText)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            Text(snapshot.categoryText + " " + String.dotText + " " + snapshot.priceLevelText)
                .foregroundColor(.gray)
                .font(.subheadline)
            RateHeader(snapshot.$rating ?? 5, totalRatings: snapshot.$userRatingsTotal ?? 0)
            Text(snapshot.$vicinity ?? "--")
                .foregroundColor(.gray)
                .font(.subheadline)
            inviteView
        }
    }
    
    var inviteView: some View {
        PresentButton(destination: LazyView(InviteView(person: nil, to: model.objectPubliser))) {
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30, maxHeight: 30)
                Text("Mời bạn bè!")
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
        }
    }
    
}

struct PlaceProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceProfileView(PreviewResource.shared.loadPlace())
    }
}