//
//  FDLocation.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import MapKit

struct FDLocation: Codable {
    var latitude: Double
    var longtitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude, longtitude
    }
    
    init(from str: String?) throws {
        guard let elements = str?.split(separator: ",")
                .compactMap({ Double($0) }),
              elements.count == 2 else {
            throw NSError()
        }
        latitude = elements.first!
        longtitude = elements.last!
    }
    
    init(_ location: CLLocation) {
        latitude = location.coordinate.latitude
        longtitude = location.coordinate.longitude
    }
    
    var toString: String {
        "\(latitude),\(longtitude)"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longtitude = try container.decode(Double.self, forKey: .longtitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longtitude, forKey: .longtitude)
    }
    
}

extension FDLocation: Equatable {
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longtitude)
    }
    
    var cllocation2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    func distance(from location: FDLocation) -> Double {
        clLocation.distance(from: location.clLocation)
    }
    
    var distanceFromCurrent: String? {
        guard let current = LibraryAPI.shared.userSnapshot?.$location else { return nil }
        let distance = self.distance(from: current)
        if distance > 1000 {
            return String(format: "%.1f km", distance / 1000.0)
        }
        return String(format: "%.0f m", distance / 1000.0)
    }
}
