import Foundation


var socket: SocketMonitor = {
    SocketMonitor(.socket, path: "ws://127.0.0.1:8000" + "/ws/notifications/\(0)/")
}()

var cancelSet = [AnyCancellable]()
func listenSocket() {
    socket.receivedPublisher
        .receive(on: RunLoop.main, options: nil)
        .sink { _ in } receiveValue: { json in
        do {
            guard let notificationData = json["notification"] as? JSON else { return }
            let notification = try FDNotification.importObject(from: notificationData)
            guard let invitationID = notification.asSnapshot(in: .defaultStack)?.$invitation?.asSnapshot(in: .defaultStack)?.$id else {
                return
            }
            AppFlow.shared.presentScreen = .invitation(invitationID)
        } catch {
            print(error.localizedDescription)
        }
    }
    .store(in: &cancelSet)
}

socket.start()
listenSocket()
