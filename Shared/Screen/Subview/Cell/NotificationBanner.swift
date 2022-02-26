//
//  NotificationBanner.swift
//  Foodate
//
//  Created by Vu Tran on 2/25/22.
//

import SwiftUI
import CoreStore

struct NotificationBanner: View {
    
    @StateObject var display = AutoDismissal()
    var notification: ObjectPublisher<FDNotification>
    
    var body: some View {
        VStack(alignment: .center) {
            NotificationCell(notification: notification)
            Color.groupTableViewBackground
                .frame(width: 70, height: 6)
                .clipShape(.stadium)
                .padding(.bottom)
        }
        .padding([.top, .leading, .trailing])
        .background(.thinMaterial)
        .offset(display.currentOffset)
        .animation(.spring(), value: 1)
        .onAppear {
            display.display(onDismiss: {
                AppFlow.shared.presentingNotification = nil
            })
        }
    }
    
}

class AutoDismissal: ObservableObject {
    
    private let onScreenInterval: TimeInterval
    @Published var currentOffset: CGSize = hidenOffset
    static var hidenOffset: CGSize = CGSize(width: 0, height: -1000)
    
    init(onScreen interval: TimeInterval = 5) {
        self.onScreenInterval = interval
    }
    
    func display(onDismiss: @escaping SuccessCallback<Void>) {
        withAnimation {
            currentOffset = .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + onScreenInterval) { [weak self] in
            withAnimation {
                self?.currentOffset = Self.hidenOffset
                onDismiss(())
            }
        }
    }
    
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        let notification: FDNotification = PreviewResource.shared.loadObject(source: "notification", ofType: "json")
        NotificationBanner(notification: notification.asPublisher(in: .defaultStack))
    }
}
