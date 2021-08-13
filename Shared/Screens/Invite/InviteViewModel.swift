//
//  InviteViewModel.swift
//  JustDate
//
//  Created by Vu Tran on 5/18/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import UIKit
import Combine
import CoreStore

enum InviteType: String, CaseIterable {
    case open = "Open"
    case direct = "Direct"
    case personal = "Private"
}

class DraftInvitation: ObservableObject {
    
    @Published var title = ""
    @Published var startAt = Date().shift(day: 1, at: 19, minute: 0) {
        didSet {
            if endAt <= startAt {
                endAt = startAt.addingTimeInterval(3600)
            }
        }
    }
    @Published var endAt = Date().shift(day: 1, at: 20, minute: 0) {
        didSet {
            if endAt <= startAt {
                startAt = endAt.addingTimeInterval(-3600)
            }
        }
    }
    @Published var toUser: ObjectPublisher<FDUserProfile>?
    @Published var place: ObjectPublisher<FDPlace>?
    @Published var shareBill = FDShareBill.fifty
    
    var isValid: Bool {
        do {
            try validate()
            return true
        } catch {
            return false
        }
    }
    
    func validate() throws {
        if place == nil {
            throw NetworkError(code: 400, message: "Bạn phải chọn địa điểm.")
        }
        if startAt < endAt, startAt < Date() {
            throw NetworkError(code: 400, message: "Thời gian bắt đầu và kết thúc không hợp lệ.")
        }
        if toUser?.isSession == true {
            throw NetworkError(code: 400, message: "Bạn không thể mời chính bạn.")
        }
        if title.isEmpty {
            throw NetworkError(code: 400, message: "Hãy điền nội dung lời mời.")
        }
    }
    
    func jsonData() -> JSON {
        var json: JSON = [
            "place": ["place_id": place?.id ?? ""],
            "title": title,
            "start_at": DateFormatter.standard.string(from: startAt),
            "end_at": DateFormatter.standard.string(from: endAt),
            "share_bill": shareBill.rawValue
        ]
        if let toUserID = toUser?.id {
            json["to_user"] = ["id": toUserID]
        }
        return json
    }
    
    func getData() -> JSONPublisher {
        Future { [unowned self] (promise) in
            do {
                try validate()
                promise(.success(self.jsonData()))
            } catch let error {
                promise(.failure(error))
            }
        }
    }
    
}

class InviteViewModel: BaseViewModel, Identifiable {
    
    @Published var draft = DraftInvitation()
    var selectionCommand = PassthroughSubject<Any, Never>()
    var createCommand = PassthroughSubject<Any?, Never>()
    var didCreateCommand = PassthroughSubject<Any?, Never>()
    
    override init() {
        super.init()
        bindSelectionCommand()
        bindDraft()
        bindCreateCommand()
    }
    
    func bindSelectionCommand() {
        selectionCommand.sink { [unowned self] object in
            if let user = object as? ObjectPublisher<FDUserProfile> {
                self.draft.toUser = user
            } else if let place = object as? ObjectPublisher<FDPlace> {
                self.draft.place = place
            }
        }
        .store(in: &cancelableSet)
    }
    
    func bindDraft() {
        draft.objectWillChange.sink { [unowned self] _ in
            self.objectWillChange.send()
        }
        .store(in: &cancelableSet)
    }
    
    func bindCreateCommand() {
        createCommand.sink(receiveValue: { [unowned self] _ in
            self.draft.getData()
                .flatMap({ NetworkService.createInvitation(parameters: $0) })
                .eraseToAnyPublisher()
                .sink { [unowned self] (result) in
                    self.error = result.error
                } receiveValue: { [unowned self] (invitation) in
                    self.didCreateCommand.send(nil)
                }
                .store(in: &cancelableSet)
        })
        .store(in: &cancelableSet)
    }
    
}
