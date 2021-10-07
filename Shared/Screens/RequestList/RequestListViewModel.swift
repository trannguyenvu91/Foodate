//
//  RequestListViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 03/08/2021.
//

import Foundation
import CoreStore
import Combine

class RequestListViewModel: BaseViewModel, ListViewModel {
    
    var acceptRequester = PassthroughSubject<ObjectSnapshot<FDRequester>, Never>()
    var invitationID: Int
    var paginator: Paginator<FDRequester>
    
    init(_ invitationID: Int) {
        self.paginator = RequestPaginator(invitationID)
        self.invitationID = invitationID
        super.init()
        bindAcceptRequester()
        asyncDo { [weak self] in
            await self?.fetchNext()
        }
    }
    
    var requesters: [ObjectSnapshot<FDRequester>] {
        items.compactMap({ $0.asSnapshot(in: .defaultStack) })
    }
    
    func bindAcceptRequester() {
        acceptRequester.sink { [unowned self] requester in
            asyncDo {
                let _ = try await NetworkService.acceptRequest(for: invitationID, requestID: requester.$requestID)
                viewDismissalModePublisher.send(true)
            }
        }
        .store(in: &cancelableSet)
    }
    
}
