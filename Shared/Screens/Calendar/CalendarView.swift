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
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            BulletinBoardView(model.invitations)
            Spacer()
        }
        .navigationBarHidden(true)
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
