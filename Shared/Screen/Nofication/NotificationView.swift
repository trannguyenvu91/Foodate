//
//  NotificationView.swift
//  Foodate
//
//  Created by Vu Tran on 12/13/21.
//

import SwiftUI
import CoreStore

struct NotificationView: View {
    
    @ObservedObject var model = NotificationViewModel()
    
    var body: some View {
        List {
            PaginationList(model.paginator) {
                EmptyResultView()
                    .asAnyView()
            } cellBuilder: {
                NotificationCell(notification: $0.asPublisher(in: .defaultStack))
                .asAnyView()
            }
        }
        .navigationTitle("Notification_Tilte".localized())
        .refreshable {
            await model.refresh()
        }
        .listStyle(PlainListStyle())
        .bindErrorAlert(to: $model)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
