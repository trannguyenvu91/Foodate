//
//  PlaceProfileViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import Foundation
import CoreStore

class PlaceProfileViewModel: BaseObjectViewModel<FDPlace>, ListViewModel {
    
    lazy var paginator: Paginator<FDInvitation> = {
        InvitationPaginator(placeID: objectID)
    }()
    
    func refresh() async {
        do {
            try await loadObject()
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}
