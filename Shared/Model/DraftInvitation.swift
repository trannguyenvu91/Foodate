//
//  DraftInvitation.swift
//  Foodate
//
//  Created by Vu Tran on 25/08/2021.
//

import Combine
import CoreStore
import Foundation

class DraftInvitation: ObservableObject {
    
    @Published var title = ""
    @Published var startAt = Date().shift(day: 1, at: 19, minute: 0)
    @Published var toUser: ObjectSnapshot<FDUserProfile>?
    @Published var place: ObjectSnapshot<FDPlace>?
    @Published var shareBill = FDShareBill.fifty
    @Published var duration: TimeInterval = 3600
    
    var endAt: Date {
        get {
            startAt.advanced(by: duration)
        }
    }
    
    var durationText: String {
        duration.hourString
    }
    
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
            throw DraftInvitationError.emptyPlace
        }
        if startAt < endAt, startAt < Date() {
            throw DraftInvitationError.invalidTime
        }
        if toUser?.isSession == true {
            throw DraftInvitationError.invalidRecipient
        }
        if title.isEmpty {
            throw DraftInvitationError.emptyTitle
        }
    }
    
    func jsonData() -> JSON {
        var json: JSON = [
            "place": ["place_id": place?.$id ?? ""],
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
    
    func getData() throws -> JSON {
        try validate()
        return jsonData()
    }
    
}
