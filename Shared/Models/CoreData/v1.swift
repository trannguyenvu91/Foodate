//
//  v1.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore
import CoreData

struct v1 {
    
}

typealias JSON = [String: Any]
typealias FDBaseUser = v1.FDBaseUser
typealias FDUser = v1.FDUser
typealias FDUserProfile = v1.FDUserProfile
typealias FDPlace = v1.FDPlace
typealias FDBasePhoto = v1.FDBasePhoto
typealias FDPhoto = v1.FDPhoto
typealias FDPlacePhoto = v1.FDPlacePhoto
typealias FDInvitation = v1.FDInvitation
typealias FDRequester = v1.FDRequester
typealias FDSessionUser = v1.FDSessionUser

//MARK: Users
extension v1 {
    
    class FDBaseUser: CoreStoreObject {
        
        @Field.Stored("id", dynamicInitialValue: { 0 })
        @objc var id: Int
        @Field.Stored("first_name")
        var firstName: String!
        @Field.Stored("last_name")
        var lastName: String!
        @Field.Stored("avatar_url")
        var avatarURL: String?
        
        func update(from source: JSON, in transaction: BaseDataTransaction) throws {
            id = source["id"] as? Int ?? 0
            firstName = source["first_name"] as? String
            lastName = source["last_name"] as? String
            avatarURL = source["avatar_url"] as? String
        }
        
    }
    
    class FDUser: FDBaseUser {
        @Field.Stored("username")
        var userName: String?
        //private
        @Field.Relationship("inbox", inverse: \.$toUser)
        private var inbox: Set<FDInvitation>
        @Field.Relationship("outbox", inverse: \.$owner)
        private var outbox: Set<FDInvitation>
        
        override func update(from source: JSON, in transaction: BaseDataTransaction) throws {
            try super.update(from: source, in: transaction)
            userName = source["username"] as? String
        }
        
    }
    
    class FDUserProfile: FDUser {
        @Field.Stored("bio")
        var bio: String?
        @Field.Stored("job")
        var job: String?
        @Field.Coded("location", coder: FieldCoders.Json.self)
        var location: FDLocation?
        @Field.Stored("birthday")
        var birthday: Date?
        @Field.Stored("email")
        var email: String?
        @Field.Relationship("photos")
        var photos: Array<FDPhoto>
        @Field.Relationship("bulletin_board")
        var bulletinBoard: Array<FDInvitation>
        @Field.Stored("bulletin_total", dynamicInitialValue: { 0 })
        var bulletinTotal: Int
        
        override func update(from source: JSON, in transaction: BaseDataTransaction) throws {
            try super.update(from: source, in: transaction)
            guard source.keys.contains("bio") else {
                return
            }
            bio = source["bio"] as? String
            job = source["job"] as? String
            location = try? FDLocation(from: source["location"] as? String)
            birthday = DateFormatter.standard.date(from: source["birthday"] as? String ?? "")
            email = source["email"] as? String
            bulletinTotal = source["bulletin_total"] as? Int ?? 0
            photos = try transaction.importObjects(Into<FDPhoto>(),
                                              sourceArray: source["photos"] as? [String] ?? [])
            avatarURL = photos.first?.baseURL
            bulletinBoard = try transaction.importUniqueObjects(Into<FDInvitation>(),
                                              sourceArray: source["bulletin_board"] as? [JSON] ?? [])
        }
    }
    
    class FDSessionUser: FDUserProfile {
        @Field.Stored("token")
        var token: String!
        
        override func update(from source: JSON, in transaction: BaseDataTransaction) throws {
            try super.update(from: source, in: transaction)
            guard source.keys.contains("token") else {
                return
            }
            token = source["token"] as? String
        }
    }
    
    class FDRequester: FDBaseUser {
        @Field.Stored("request_id", dynamicInitialValue: { 0 })
        @objc var requestID: Int
        //private
        @Field.Relationship("invitation", inverse: \.$requests)
        private var invitation: FDInvitation?
        
        override func update(from source: JSON, in transaction: BaseDataTransaction) throws {
            try super.update(from: source, in: transaction)
            requestID = source["request_id"] as? Int ?? 0
        }
    }

}

//MARK: Photos
extension v1 {
    
    class FDBasePhoto: CoreStoreObject {
        @Field.Stored("base_url")
        var baseURL: String!
    }
    
    class FDPhoto: FDBasePhoto {
        //private
        @Field.Relationship("owner", inverse: \.$photos)
        private var owner: FDUserProfile?
    }
    
    class FDPlacePhoto: FDBasePhoto {
        @Field.Stored("width")
        var width: Double!
        @Field.Stored("height")
        var height: Double!
        //private
        @Field.Relationship("place", inverse: \.$photos)
        private var place: FDPlace?
    }
    
}

//MARK: Place
extension v1 {
    
    class FDPlace: CoreStoreObject {
        @Field.Stored("place_id", dynamicInitialValue: { "" })
        @objc var id: String
        @Field.Stored("name")
        var name: String!
        @Field.Coded("location", coder: FieldCoders.Json.self)
        var location: FDLocation!
        @Field.Stored("price_level")
        var priceLevel: Double!
        @Field.Stored("rating")
        var rating: Double!
        @Field.Stored("user_ratings_total")
        var userRatingsTotal: Int!
        @Field.Stored("vicinity")
        var vicinity: String!
        @Field.Stored("business_status")
        var businessStatus: FDBusinessStatus!
        @Field.Stored("types", dynamicInitialValue: { [] })
        var types: SimpleStringSet
        @Field.Relationship("photos")
        var photos: Array<FDPlacePhoto>
        //private
        @Field.Relationship("invitations", inverse: \.$place)
        private var invitations: Set<FDInvitation>
    }
    
}

//MARK: Invitation
extension v1 {
    
    class FDInvitation: CoreStoreObject {
        @Field.Stored("id", dynamicInitialValue: { 0 })
        @objc var id: Int
        @Field.Stored("title")
        var title: String?
        @Field.Stored("start_at")
        var startAt: Date!
        @Field.Stored("end_at")
        var endAt: Date!
        @Field.Stored("state")
        var state: FDInvitationState!
        @Field.Stored("share_bill")
        var shareBill: FDShareBill!
        @Field.Stored("requests_total")
        var requestsTotal: Int!
        @Field.Relationship("requests")
        var requests: Array<FDRequester>
        @Field.Relationship("place")
        var place: FDPlace!
        @Field.Relationship("to_user")
        var toUser: FDUser?
        @Field.Relationship("owner")
        var owner: FDUser!
        //private
        @Field.Relationship("in_bullentin_users", inverse: \.$bulletinBoard)
        private var inBullentinUsers: Set<FDUserProfile>
    }
    
}

