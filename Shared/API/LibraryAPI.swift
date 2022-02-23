//
//  LibraryAPI.swift
//  Foodate
//
//  Created by Vu Tran on 2/14/22.
//

import Foundation
import CoreStore
import CoreLocation
import UserNotifications
import Alamofire

typealias SuccessCallback<T> = (T) -> Void

class LibraryAPI {
    
    static var shared: LibraryAPI!
    var userSnapshot: ObjectSnapshot<FDSessionUser>?
    
    private let database = try! PersistanceService()
    private let networkService = NetworkService(.standard)
    private let locationService = LocationService(.standard)
    private var notificationService: NotificationService
    
    init(_ application: Application) {
        notificationService = NotificationService(center: .current,
                                                  application: application)
        try? resetSessionUser()
    }
    
    func resetSessionUser() throws {
        userSnapshot = try database.fetchOne(FDSessionUser.self)?
            .asSnapshot()
    }
    
    func logOut() throws {
        userSnapshot = nil
        try database.deleteAll(FDSessionUser.self)
    }
    
}

//MARK: Location
extension LibraryAPI {
    
    var isLocationPermissionGranted: Bool {
        locationService.isPermissionGranted
    }
    
    func updateUserLocation() async throws {
        let location = try await locationService.requestLocation()
        try await userSnapshot?.update(location: location)
    }
    
}

//MARK: Notification
extension LibraryAPI {
    
    func didReceiveNotification(token: String?, error: Error?) {
        notificationService.didReceive(token: token, error: error)
    }
    
    func didReceiveNotification(_ notification: UNNotification) async {
        //TODO: Popup banner for in app noti
        AppFlow.shared.pushedScreen = .invitation(71)
    }
    
    var notificationSettings: UNNotificationSettings {
        get async {
            await notificationService.notificationSettings
        }
    }
    
    var notificationAuthorizationStatus: UNAuthorizationStatus {
        get async {
            await notificationService.authorizationStatus
        }
    }
    
    func updateNotificationToken() async throws {
        let token = try await notificationService.registerNotifications()
        try await userSnapshot?.update(notificationToken: token)
    }
    
}

//MARK: Database
extension LibraryAPI {
    
    @discardableResult
    func deleteAll<O>(_ type: O.Type,
                      condition: Where<O> = .init(true)) throws -> Int where O: CoreStoreObject {
        try database.deleteAll(type, condition: condition)
    }
    
    @discardableResult
    func saveUniqueObject<O>(_ type: O.Type,
                             from source: O.ImportSource) throws -> O where O: CoreStoreObject & ImportableUniqueObject {
        try database.saveUniqueObject(type, from: source)
    }
    
    @discardableResult
    func saveUniqueObjects<O>(_ type: O.Type,
                              from source: [O.ImportSource]) throws -> [O] where O: CoreStoreObject & ImportableUniqueObject {
        try database.saveUniqueObjects(type, from: source)
    }
    
    @discardableResult
    func saveObject<O>(_ type: O.Type,
                             from source: O.ImportSource) throws -> O where O: CoreStoreObject & ImportableObject {
        try database.saveObject(type, from: source)
    }
    
    @discardableResult
    func saveObjects<O>(_ type: O.Type,
                              from source: [O.ImportSource]) throws -> [O] where O: CoreStoreObject & ImportableObject {
        try database.saveObjects(type, from: source)
    }
    
    func fetchOne<O>(_ type: O.Type,
                     condition: Where<O> = .init(true)) throws -> O? where O: CoreStoreObject {
        try database.fetchOne(type, condition: condition)
    }
    
    func fetchOne<O: ImportableUniqueObject>(_ type: O.Type, id: O.UniqueIDType) throws -> O? where O: CoreStoreObject {
        let condition = Where<O>(O.uniqueIDKeyPath, isEqualTo: id)
        return try database.fetchOne(type, condition: condition)
    }
    
    func fetchAll<O>(_ type: O.Type,
                     condition: Where<O> = .init(true)) throws -> [O] where O: CoreStoreObject {
        try database.fetchAll(type, condition: condition)
    }
    
    var dataStack: DataStack {
        database.dataStack
    }
    
}

//MARK:
extension LibraryAPI {
    
    private var httpHeaders: HTTPHeaders {
        var headers = ["Content-Type": "application/json"]
        if let token = userSnapshot?.$token {
            headers["Authorization"] = tokenPrefix + token
        }
        return HTTPHeaders(headers)
    }
    
    func request<Result: ImportableJSONObject>(url: String?,
                                               method: HTTPMethod = .get,
                                               parameters: JSON? = nil) async throws -> Result {
        guard let url = url else {
            throw NetworkError(code: 999, message: "There is not a next page")
        }
        return try await networkService.request(url: url,
                                         method: method,
                                         parameters: parameters,
                                         headers: httpHeaders)
    }
    
    func request<Result: ImportableJSONObject>(api: String?,
                                               method: HTTPMethod = .get,
                                               parameters: JSON? = nil) async throws -> Result {
        guard let api = api else {
            throw NetworkError(code: 999, message: "There is not a next page")
        }
        return try await networkService.request(url: serverBaseURL + api,
                                         method: method,
                                         parameters: parameters,
                                         headers: httpHeaders)
    }
    
    func requestNext<Item>(of page: NetworkPage<Item>) async throws -> NetworkPage<Item> {
        try await request(url: page.nextURL, parameters: page.params)
    }

    //MARK: User
    func login(@Lowercased username: String, password: String) async throws -> FDSessionUser  {
        try await request(url: serverBaseURL + "/api/v1/auth/login",
                          method: .post,
                          parameters: ["username": username, "password": password])
    }
    
    func register(@Lowercased username: String,
                  password: String,
                  email: String) async throws -> FDSessionUser {
        let _: JSON = try await request(api: "/api/v1/auth/register",
                                        method: .post,
                                        parameters: ["username": username, "password": password, "email": email])
        return try await login(username: username, password: password)
    }
    
    func reset(@Lowercased username: String,
               password: String) async throws -> FDSessionUser {
        let _: JSON = try await request(api: "/api/v1/auth/reset",
                                        method: .post,
                                        parameters: ["username": username, "password": password])
        return try await login(username: username, password: password)
    }
    
    func updateUser(ID: Int, parameters: JSON) async throws -> FDUserProfile {
        try await request(api: "/api/v1/users/\(ID)/",
                          method: .patch,
                          parameters: parameters)
    }
    
    func getUser(ID: Int, success: SuccessCallback<FDUserProfile>) async throws {
        if let local = try? fetchOne(FDUserProfile.self,
                                     condition: Where<FDUserProfile>(FDUserProfile.uniqueIDKeyPath, ID)) {
            success(local)
        }
        let remote: FDUserProfile = try await request(api: "/api/v1/users/\(ID)/",
                          method: .get,
                          parameters: nil)
        success(remote)
    }
    
    //MARK: Invitation
    func getInvitation(ID: Int, success: SuccessCallback<FDInvitation>) async throws {
        if let local = try? fetchOne(FDInvitation.self,
                                     condition: Where<FDInvitation>(FDInvitation.uniqueIDKeyPath, ID)) {
            success(local)
        }
        let remote: FDInvitation = try await request(api: "/api/v1/invitations/\(ID)/")
        success(remote)
    }
    
    func deleteInvitation(ID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/",
                          method: .delete)
    }
    
    func updateInvitation(ID: Int, parameters: JSON) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/",
                          method: .put,
                          parameters: parameters)
    }
    
    func replyInvitation(ID: Int, state: InvitationState) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/reply/",
                          method: .post,
                          parameters: ["state": state.rawValue])
    }
    
    func createInvitation(parameters: JSON) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/",
                          method: .post,
                          parameters: parameters)
    }
    
    //MARK: Request
    func createRequest(for invitationID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(invitationID)/requests/",
                          method: .post)
    }
    
    func deleteRequest(for invitationID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(invitationID)/requests/0/",
                          method: .delete)
    }
    
    func acceptRequest(for invitationID: Int, requestID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(invitationID)/requests/\(requestID)/accept/",
                          method: .post)
    }
    
    //MARK: Place
    func getPlace(ID: String, success: SuccessCallback<FDPlace>) async throws {
        if let local = try? fetchOne(FDPlace.self,
                                     condition: Where<FDPlace>(FDPlace.uniqueIDKeyPath, ID)) {
            success(local)
        }
        let remote: FDPlace = try await request(api: "/api/v1/places/\(ID)/")
        success(remote)
    }
    
}

