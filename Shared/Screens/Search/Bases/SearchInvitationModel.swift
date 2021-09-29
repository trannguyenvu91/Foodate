//
//  SearchInvitationModel.swift
//  SearchInvitationModel
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation
import CoreStore

class SearchInvitationModel: BaseViewModel, ListViewModel {
    
    var paginator: Paginator<FDInvitation>
    
    override init() {
        self.paginator = SearchInvitationPaginator(nil)
        super.init()
        asyncDo { [weak self] in
            try await self?.fetchNext()
        }
    }
    
    var invitations: [ObjectPublisher<FDInvitation>] {
        items.map({ $0.asPublisher(in: .defaultStack) })
    }

}
