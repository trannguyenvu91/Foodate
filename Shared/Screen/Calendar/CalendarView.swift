//
//  CalendarView.swift
//  Foodate
//
//  Created by Vu Tran on 04/10/2021.
//

import SwiftUI
import Combine

struct CalendarView: View {
    
    @ObservedObject var model = CalendarViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello_User_Title".localized(with: [AppConfig.shared.sessionUser?.name ?? ""]))
                .font(.title)
                .fontWeight(.bold)
                .padding([.leading, .top])
            Picker("", selection: $model.selectedTab) {
                ForEach(CalendarType.allCases, id: \.self) { type in
                    Text(type.title)
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, -16)
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
        .navigationBarHidden(true)
        .listStyle(PlainListStyle())
        .refreshable {
            await model.refresh()
        }
    }
    
    var eventsList: some View {
        PaginationList(model.eventsPaginator) {
            InviteCell()
                .asAnyView()
        } cellBuilder: {
            InvitationCell($0.asPublisher(in: .defaultStack))
                .asAnyView()
        }
    }
    
    var inboxList: some View {
        PaginationList(model.inboxPaginator) {
            EmptyResultView()
                .asAnyView()
        } cellBuilder: {
            InvitationCell($0.asPublisher(in: .defaultStack))
                .asAnyView()
        }
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
