//
//  FDPlace.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore
import MapKit
import ObjectMapper

enum FDBusinessStatus: String {
    
    case closedTemporarily = "CLOSED_TEMPORARILY"
    case operational = "OPERATIONAL"
    case closedPermanently = "CLOSED_PERMANENTLY"
}

enum FDShareBill: String, CaseIterable {
    case fifty = "50"
    case seventy = "70"
    case oneHundred = "100"
    
}

enum PlaceType: String {
    case cafe = "cafe"
    case food = "food"
    case bakery = "bakery"
    case bar = "bar"
    case liquorStore = "liquor_store"
    case restaurant = "restaurant"
    case others
    
    var descriptionText: String {
        switch self {
        case .cafe:
            return "PlaceType_Cafe".localized()
        case .food:
            return "PlaceType_Food".localized()
        case .bakery:
            return "PlaceType_Bakery".localized()
        case .bar:
            return "PlaceType_Bar".localized()
        case .liquorStore:
            return "PlaceType_LiquorStore".localized()
        case .restaurant:
            return "PlaceType_Restaurant".localized()
        case .others:
            return "PlaceType_Others".localized()
        }
    }
    
}

extension ObjectSnapshot where O: FDPlace {
    
    var priceLevelText: String {
        Array(repeating: "$", count: Int(self.$priceLevel ?? 1)).joined()
    }
    
    var distanceText: String {
        self.$location?.distanceFromCurrent ?? "--"
    }
    
    var categoryText: String {
        self.$types
            .split(separator: ",")
            .compactMap({ PlaceType(rawValue: String($0)) })
            .first?
            .descriptionText ?? PlaceType.others.descriptionText
    }
    
    var avatarURL: String {
        self.$photos.first?.asSnapshot(in: .defaultStack)?.$baseURL ?? ""
    }
    
    var locationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.$location?.latitude ?? 0, longitude: self.$location?.longtitude ?? 0)
    }
    
    var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: locationCoordinate2D, latitudinalMeters: 100, longitudinalMeters: 100)
    }
    
}

extension FDPlace: RemoteObject, ImportableJSONObject {
    
    static func importObject(from source: JSON) throws -> Self {
        try DataStack.defaultStack.perform { transaction in
            try transaction.importUniqueObject(Into<Self>(), source: source)!
        }
    }
    
    static var uniqueIDKeyPath: String {
        "place_id"
    }
    
    static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> String? {
        source[uniqueIDKeyPath] as? String
    }
    
    func update(from source: JSON, in transaction: BaseDataTransaction) throws {
        let map = Map(mappingType: .fromJSON, JSON: source)
        id <- map["place_id"]
        name <- map["name"]
        priceLevel <- map["price_level"]
        rating <- map["rating"]
        userRatingsTotal <- map["user_ratings_total"]
        vicinity <- map["vicinity"]
        businessStatus <- map["business_status"]
        types <- map["types"]
        location  <- (map["location"], LocationTransform())
        photos = try transaction.importObjects(Into<FDPlacePhoto>(), sourceArray: source["photos"] as? [JSON] ?? [])
    }
    
    typealias UniqueIDType = String
    typealias ImportSource = JSON

    static func fetchRemoteObject(id: String) async throws -> Self {
        try await LibraryAPI.shared.getPlace(ID: id) as! Self
    }
    
}
