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
        fetchNext()
        bindAcceptRequester()
    }
    
    var requesters: [ObjectSnapshot<FDRequester>] {
        items.compactMap({ $0.asSnapshot(in: .defaultStack) })
    }
    
    func bindAcceptRequester() {
        let publisher = acceptRequester.flatMap({ [unowned self] in
            NetworkService.acceptRequest(for: self.invitationID, requestID: $0.$requestID)
        }).eraseToAnyPublisher()
        execute(publisher: publisher) { [weak self] _ in
            self?.viewDismissalModePublisher.send(true)
        }
    }
    
}
