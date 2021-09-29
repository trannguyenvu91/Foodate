//
//  SearchUserModel.swift
//  SearchUserModel
//
//  Created by Vu Tran on 28/07/2021.
//

import Foundation
import CoreStore

class SearchUserModel: BaseViewModel, ListViewModel {
    
    var paginator: Paginator<FDUserProfile>
    
    override init() {
        self.paginator = SearchProfilePaginator(nil)
        super.init()
        asyncDo { [weak self] in
            try await self?.fetchNext()
        }
    }
    
    var users: [ObjectPublisher<FDUserProfile>] {
        items.map({ $0.asPublisher(in: .defaultStack) })
    }
}
