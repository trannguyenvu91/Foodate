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
        VStack {
            Picker("", selection: $model.selectedTab) {
                ForEach(CalendarType.allCases, id: \.self) { type in
                    Text(type.title)
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            List {
                BulletinBoardView(model.invitations) {
                    Task { await model.fetchNext() }
                }
            }
        }
        .navigationBarHidden(true)
        .listStyle(PlainListStyle())
        .refreshable {
            await model.refresh()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
