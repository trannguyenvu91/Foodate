//
//  ClockService.swift
//  Foodate
//
//  Created by Vu Tran on 2/8/22.
//

import Foundation
import SwiftUI

@propertyWrapper
struct ClockService: DynamicProperty {
    
    @ObservedObject private var refresher: Refresher
    
    var wrappedValue: TimeInterval {
        refresher.lastUpdatedAt
    }
    
    init(_ interval: TimeInterval? = nil) {
        if let interval = interval {
            self.refresher = Refresher(interval: interval)
        } else {
            self.refresher = .shared
        }
    }
    
}

internal class Refresher: ObservableObject {
    static let shared = Refresher()
    @Published var lastUpdatedAt: TimeInterval = 0
    private(set) var interval: TimeInterval
    lazy var timer: Timer = {
        Timer.scheduledTimer(timeInterval: interval,
                             target: self,
                             selector: #selector(refreshing),
                             userInfo: nil,
                             repeats: true)
    }()
    
    init(interval: TimeInterval = 60) {
        self.interval = interval
        timer.fire()
    }
    
    @objc func refreshing() {
        lastUpdatedAt = Date.now.timeIntervalSince1970
        objectWillChange.send()
    }
    
    deinit {
        timer.invalidate()
    }
    
}
