//
//  CLLocationCoordinate2D.swift
//  JustDate
//
//  Created by Vu Tran on 7/17/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import MapKit

extension CLLocation {
    var distanceFromCurrent: String? {
        guard let current = AppFlow.shared.sessionUser?.$location?.clLocation  else { return nil }
        let distance = self.distance(from: current)
        if distance > 1000 {
            return String(format: "%.1f km", distance / 1000.0)
        }
        return String(format: "%.0f m", distance / 1000.0)
    }
    
    convenience init(_ location: FDLocation) {
        self.init()
    }
}
