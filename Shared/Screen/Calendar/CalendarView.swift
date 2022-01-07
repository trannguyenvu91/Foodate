//
//  CalendarView.swift
//  Foodate
//
//  Created by Vu Tran on 04/10/2021.
//

import SwiftUI
import Combine

struct CalendarView: View {
    
    @StateObject var model = CalendarViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $model.selectedTab) {
                ForEach(CalendarType.allCases, id: \.self) { type in
                    Text(type.title)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
            List {
                switch model.selectedTab {
                case .events:
                    eventsList
                default:
                    inboxList
                }
            }
        }
        .navigationTitle(
            "Hello_User_Title".localized(with: [AppConfig.shared.sessionUser?.name ?? ""])
        )
        .listStyle(.plain)
        .refreshable {
            await model.refresh()
        }
    }
    
    var eventsList: some View {
        PaginationList(model.eventsPaginator) {
            InviteCell()
        } cellBuilder: {
            InvitationCell(model: .init($0.asPublisher(in: .defaultStack)))
        }
    }
    
    var inboxList: some View {
        PaginationList(model.inboxPaginator) {
            EmptyResultView()
        } cellBuilder: {
            InvitationCell(model: .init($0.asPublisher(in: .defaultStack)))
        }
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
