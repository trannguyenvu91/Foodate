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
            throw NetworkError(code: 400, message: "DraftInvitation_Empty_Place_Alert".localized())
        }
        if startAt < endAt, startAt < Date() {
            throw NetworkError(code: 400, message: "DraftInvitation_Invalid_Time_Alert".localized())
        }
        if toUser?.isSession == true {
            throw NetworkError(code: 400, message: "DraftInvitation_Recipient_Alert".localized())
        }
        if title.isEmpty {
            throw NetworkError(code: 400, message: "DraftInvitation_Empty_Title_Alert".localized())
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
