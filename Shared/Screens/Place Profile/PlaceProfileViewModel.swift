//
//  PlaceProfileViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import Foundation
import CoreStore

class PlaceProfileViewModel: ObjectBaseViewModel<FDPlace>, ListViewModel {
    
    var paginator: Paginator<FDInvitation>
    
    override init(_ place: ObjectPublisher<FDPlace>) {
        self.paginator = InvitationPaginator.paginator(placeID: place.id!)
        super.init(place)
    }
    
    var invitations: [ObjectPublisher<FDInvitation>] {
        paginator.items.compactMap({ $0.asPublisher(in: .defaultStack) })
    }
    
    func refresh() async {
        guard let id = objectPubliser.id else {
            return
        }
        do {
            let _ = try await NetworkService.getPlace(ID: id)
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}
