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
    
    @ObservedObject private var refresher = Refresher.shared
    
    var wrappedValue: TimeInterval {
        refresher.lastUpdatedAt
    }
    
    private class Refresher: ObservableObject {
        static let shared = Refresher()
        @Published var lastUpdatedAt: TimeInterval = 0
        let interval: TimeInterval = 60
        lazy var timer: Timer = {
            Timer.scheduledTimer(timeInterval: interval,
                                 target: self,
                                 selector: #selector(refreshing),
                                 userInfo: nil,
                                 repeats: true)
        }()
        
        init() {
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
    
}
