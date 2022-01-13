//
//  Tests_NotificationService.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import XCTest
import UserNotifications

class Tests_NotificationService: BaseTestCase {
    
    let application = MockUIApplication()
    let appDelegate = AppDelegate()
    let center = MockUserNotificationCenter()
    
    lazy var service: NotificationService = {
        let instance = NotificationService()
        instance.application = application
        instance.center = center
        return instance
    }()

    override func setUpWithError() throws {
        NotificationService.shared = service
        application.delegate = appDelegate
        UNNotificationSettings.swizzleAuthorizationStatus()
    }

    func testRequestAuthorization() async throws {
        center._requestAuthorizationResult = true
        var request = try await service.requestAuthorization()
        XCTAssertTrue(request)
        center._requestAuthorizationResult = false
        request = try await service.requestAuthorization()
        XCTAssertFalse(request)
    }
    
    func testAuthorizationStatus() async {
        UNNotificationSettings.fakeAuthorizationStatus = .denied
        var status = await service.getAuthorizationStatus()
        XCTAssertEqual(status, .denied)
        UNNotificationSettings.fakeAuthorizationStatus = .authorized
        status = await service.getAuthorizationStatus()
        XCTAssertEqual(status, .authorized)
        UNNotificationSettings.fakeAuthorizationStatus = .notDetermined
        status = await service.getAuthorizationStatus()
        XCTAssertEqual(status, .notDetermined)
    }
    
    func testRegisterNotificationsError() async throws {
        center._requestAuthorizationResult = false
        do {
            let _ = try await service.registerNotifications()
        } catch {
            XCTAssertEqual(error as? NotificationError, NotificationError.notGranted)
        }
        //Granted
        center._requestAuthorizationResult = true
        application._notificationRegisterResult = .error(NotificationError.notAvailable)
        do {
            let _ = try await service.registerNotifications()
        } catch {
            XCTAssertEqual(error as? NotificationError, NotificationError.notAvailable)
        }
    }
    
    func testRegisterNotificationsSuccess() async throws {
        let token = "740f4707"
        center._requestAuthorizationResult = true
        application._notificationRegisterResult = .success(token)
        let registeredToken = try await service.registerNotifications()
        XCTAssertEqual(token, registeredToken)
    }
    
}
