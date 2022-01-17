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
            return "Quán cà phê"
        case .food:
            return "Đồ ăn"
        case .bakery:
            return "Tiệm bánh"
        case .bar:
            return "Quán bar, pub"
        case .liquorStore:
            return "Quán rượu"
        case .restaurant:
            return "Nhà hàng"
        default:
            return "Others"
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
            .descriptionText ?? "Others"
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
        try await NetworkService.getPlace(ID: id) as! Self
    }
    
}
