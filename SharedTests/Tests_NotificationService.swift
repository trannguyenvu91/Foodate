//
//  Tests_NotificationService.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import XCTest
import UserNotifications

class Tests_NotificationService: BaseTestCase {
    
    lazy var service: NotificationService = {
        NotificationService(center: notificationCenter, application: application)
    }()

    override func setUpWithError() throws {
        try super.setUpWithError()
        UNNotificationSettings.swizzleAuthorizationStatus()
    }

    func testRequestAuthorization() async throws {
        notificationCenter._requestAuthorizationResult = true
        var request = try await service.requestAuthorization()
        XCTAssertTrue(request)
        notificationCenter._requestAuthorizationResult = false
        request = try await service.requestAuthorization()
        XCTAssertFalse(request)
    }
    
    func testAuthorizationStatus() async {
        UNNotificationSettings.fakeAuthorizationStatus = .denied
        var status = await service.authorizationStatus
        XCTAssertEqual(status, .denied)
        UNNotificationSettings.fakeAuthorizationStatus = .authorized
        status = await service.authorizationStatus
        XCTAssertEqual(status, .authorized)
        UNNotificationSettings.fakeAuthorizationStatus = .notDetermined
        status = await service.authorizationStatus
        XCTAssertEqual(status, .notDetermined)
    }
    
    func testRegisterNotificationsError() async throws {
        notificationCenter._requestAuthorizationResult = false
        do {
            let _ = try await service.registerNotifications()
        } catch {
            XCTAssertEqual(error as? NotificationError, NotificationError.notGranted)
        }
        //Granted
        notificationCenter._requestAuthorizationResult = true
        application._notificationRegisterResult = .error(NotificationError.notAvailable)
        do {
            let _ = try await service.registerNotifications()
        } catch {
            XCTAssertEqual(error as? NotificationError, NotificationError.notAvailable)
        }
    }
    
    func testRegisterNotificationsSuccess() async throws {
        let token = "740f4707"
        notificationCenter._requestAuthorizationResult = true
        application._notificationRegisterResult = .success(token)
        let registeredToken = try await service.registerNotifications()
        XCTAssertEqual(token, registeredToken)
    }
    
}
