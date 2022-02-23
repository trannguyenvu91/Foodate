//
//  NotificationView.swift
//  Foodate
//
//  Created by Vu Tran on 12/13/21.
//

import SwiftUI
import CoreStore

struct NotificationView: View {
    
    @StateObject var model = NotificationViewModel()
    
    var body: some View {
        List {
            PaginationList(model.paginator) {
                EmptyResultView()
            } cellBuilder: {
                NotificationCell(notification: $0.asPublisher(in: .defaultStack))
            }
        }
        .navigationTitle("Notification_Tilte".localized())
        .refreshable {
            await model.refresh()
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .bindErrorAlert(to: $model)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
