//
//  PlaceProfileView.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import SwiftUI
import CoreStore

struct PlaceProfileView: View {
    
    @StateObject var model: PlaceProfileViewModel
    
    var body: some View {
        GeometryReader { proxy in
            List {
                ObjectReader(model.objectPublisher) { snapshot in
                    PhotosPageView(snapshot.$photos)
                        .listRowInsets(EdgeInsets())
                        .frame(width: proxy.size.width, height: proxy.size.width)
                        .navigationTitle(snapshot.$name ?? "Địa điểm")
                    placeInfoView(snapshot)
                }
                PaginationList(model.paginator) {
                    InviteCell(nil, to: model.objectPublisher)
                } cellBuilder: {
                    InvitationCell(model: .init($0.asPublisher(in: .defaultStack)), showPlace: false)
                }
            }
        }
        .taskOnLoad(error: $model.error) {
            try await model.getProfile()
        }
        .refreshable {
            await self.model.refresh()
        }
        .bindErrorAlert(to: $model)
        .ignoresSafeArea()
        .listStyle(.plain)
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
            categoryView(snapshot)
            RateHeader(snapshot.$rating ?? 5, totalRatings: snapshot.$userRatingsTotal ?? 0)
            Text(snapshot.$vicinity ?? "--")
                .foregroundColor(.gray)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            inviteView
        }
    }
    
    func categoryView(_ snapshot: ObjectSnapshot<FDPlace>) -> some View {
        let text = snapshot.categoryText + " " + String.dotText + " " + snapshot.priceLevelText
        return Text(text)
            .font(.subheadline)
            .foregroundColor(.gray)
    }
    
    var inviteView: some View {
        PresentButton(destination: LazyView(InviteView(nil, to: model.objectPublisher))) {
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
        PlaceProfileView(model: .init(PreviewResource.shared.loadPlace()))
    }
}
