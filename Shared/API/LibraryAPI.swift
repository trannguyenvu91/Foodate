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
import Combine

typealias SuccessCallback<T> = (T) -> Void

class LibraryAPI {
    
    static var shared: LibraryAPI!
    var userSnapshot: ObjectSnapshot<FDSessionUser>?
    var newInvitation = PassthroughSubject<FDInvitation, Never>()
    
    private let persistance: PersistanceService
    private let networkService: NetworkService
    private let locationService: LocationService
    private var notificationService: NotificationService
    private(set) var notificationSocketMonitor: NotificationSocketMonitor?
    
    init(_ application: Application,
         persistance: PersistanceService = try! PersistanceService(),
         networkService: NetworkService = NetworkService(.standard),
         locationService: LocationService = LocationService(.standard)) {
        self.persistance = persistance
        self.networkService = networkService
        self.locationService = locationService
        self.notificationService = NotificationService(center: .current,
                                                  application: application)
        try? resetSessionUser()
        observeReceivingNotificationResponse()
    }
    
    func resetSessionUser() throws {
        userSnapshot = try persistance.fetchOne(FDSessionUser.self)?
            .asSnapshot()
        try resetSocketMonitor()
    }
    
    func logOut() throws {
        try persistance.deleteAll(FDSessionUser.self)
        try resetSessionUser()
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
    
    func didReceiveNotification(_ notification: UNNotification, completionHandler: SuccessCallback<Void>) {
        //TODO: Popup banner for in app noti
        AppFlow.shared.pushedScreen = .invitation(71)
        completionHandler(())
    }
    
    func receivedUpdate(on notification: FDNotification) {
        AppFlow.shared.presentingNotification = notification
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
    
    internal func observeReceivingNotificationResponse() {
        NotificationCenter.default.addObserver(forName: .didReceiveNotificationResponse, object: nil, queue: nil) { [weak self] noti in
            guard let userInfo = noti.userInfo,
            let response = userInfo["response"] as? UNNotificationResponse,
                let handler = userInfo["handler"] as? SuccessCallback<Void> else {
                return
            }
            self?.didReceiveNotification(response.notification,
                                         completionHandler: handler)
        }
    }
    
    //Notification Socket
    internal func resetSocketMonitor() throws {
        notificationSocketMonitor?.stop()
        notificationSocketMonitor = nil
        guard let id = userSnapshot?.$id else {
            return
        }
        notificationSocketMonitor = try NotificationSocketMonitor(userID: id)
        notificationSocketMonitor?.observe({ [weak self] notification in
            DispatchQueue.main.async {
                self?.receivedUpdate(on: notification)
            }
        })
    }
    
}

//MARK: Database
extension LibraryAPI {
    
    @discardableResult
    func deleteAll<O>(_ type: O.Type,
                      condition: Where<O> = .init(true)) throws -> Int where O: CoreStoreObject {
        try persistance.deleteAll(type, condition: condition)
    }
    
    @discardableResult
    func saveUniqueObject<O>(_ type: O.Type,
                             from source: O.ImportSource) throws -> O where O: CoreStoreObject & ImportableUniqueObject {
        try persistance.saveUniqueObject(type, from: source)
    }
    
    @discardableResult
    func saveUniqueObjects<O>(_ type: O.Type,
                              from source: [O.ImportSource]) throws -> [O] where O: CoreStoreObject & ImportableUniqueObject {
        try persistance.saveUniqueObjects(type, from: source)
    }
    
    @discardableResult
    func saveObject<O>(_ type: O.Type,
                             from source: O.ImportSource) throws -> O where O: CoreStoreObject & ImportableObject {
        try persistance.saveObject(type, from: source)
    }
    
    @discardableResult
    func saveObjects<O>(_ type: O.Type,
                              from source: [O.ImportSource]) throws -> [O] where O: CoreStoreObject & ImportableObject {
        try persistance.saveObjects(type, from: source)
    }
    
    func fetchOne<O>(_ type: O.Type,
                     condition: Where<O> = .init(true)) throws -> O? where O: CoreStoreObject {
        try persistance.fetchOne(type, condition: condition)
    }
    
    func fetchOne<O: ImportableUniqueObject>(_ type: O.Type, id: O.UniqueIDType) throws -> O? where O: CoreStoreObject {
        let condition = Where<O>(O.uniqueIDKeyPath, isEqualTo: id)
        return try persistance.fetchOne(type, condition: condition)
    }
    
    func fetchAll<O>(_ type: O.Type,
                     condition: Where<O> = .init(true)) throws -> [O] where O: CoreStoreObject {
        try persistance.fetchAll(type, condition: condition)
    }
    
    var dataStack: DataStack {
        persistance.dataStack
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
    
    @MainActor
    func request<Result: ImportableJSONObject>(url: String?,
                                               method: HTTPMethod = .get,
                                               parameters: JSON? = nil) async throws -> Result {
        guard let url = url else {
            throw NetworkError.invalidAPI(url)
        }
        return try await networkService.request(url: url,
                                         method: method,
                                         parameters: parameters,
                                         headers: httpHeaders)
    }
    
    @MainActor
    func request<Result: ImportableJSONObject>(api: String?,
                                               method: HTTPMethod = .get,
                                               parameters: JSON? = nil) async throws -> Result {
        guard let api = api else {
            throw NetworkError.invalidAPI(api)
        }
        return try await networkService.request(url: serverBaseURL + api,
                                         method: method,
                                         parameters: parameters,
                                         headers: httpHeaders)
    }
    
    @MainActor
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
    
    @MainActor
    func getUser(ID: Int, success: SuccessCallback<ObjectPublisher<FDUserProfile>?>) async throws {
        let local = try? fetchOne(FDUserProfile.self, id: ID)?
            .asPublisher(in: .defaultStack)
        success(local)
        let remote: FDUserProfile = try await request(api: "/api/v1/users/\(ID)/")
        if local == nil {
            success(remote.asPublisher(in: .defaultStack))
        }
    }
    
    //MARK: Invitation
    @MainActor
    func getInvitation(ID: Int, success: SuccessCallback<ObjectPublisher<FDInvitation>?>) async throws {
        let local = try? fetchOne(FDInvitation.self, id: ID)?
            .asPublisher(in: .defaultStack)
        success(local)
        let remote: FDInvitation = try await request(api: "/api/v1/invitations/\(ID)/")
        if local == nil {
            success(remote.asPublisher(in: .defaultStack))
        }
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
    @MainActor
    func getPlace(ID: String, success: SuccessCallback<ObjectPublisher<FDPlace>?>) async throws {
        let local = try? fetchOne(FDPlace.self, id: ID)?.asPublisher(in: .defaultStack)
        success(local)
        let remote: FDPlace = try await request(api: "/api/v1/places/\(ID)/")
        if local == nil {
            success(remote.asPublisher(in: .defaultStack))
        }
    }
    
}

