//
//  SearchView.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 28/07/2021.
//

import SwiftUI
import Combine

struct SearchView: View {

    @ObservedObject var model: SearchViewModel
    var selectionCommand: PassthroughSubject<Any, Never>?
    @Environment(\.presentationMode) var presentationMode
    
    init(_ tabs: [SearchType] = SearchType.allCases,
         selectionCommand: PassthroughSubject<Any, Never>? = nil) {
        self.selectionCommand = selectionCommand
        self.model = SearchViewModel(tabs)
    }
    
    var body: some View {
        VStack {
            searchBar
            if model.tabs.count > 1 {
                switchView
            }
            List {
                switch model.type {
                case .account:
                    userList
                case .invitation:
                    invitationList
                case .place:
                    placeList
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Search")
        .navigationBarHidden(true)
        .bindErrorAlert(to: $model)
        .onReceive(selectionCommand ?? PassthroughSubject<Any, Never>()) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
        .refreshable {
            await model.refresh()
        }
    }
    
    var searchBar: some View {
        HStack(spacing: 10) {
            TextField("SearchView_Search_PlaceHolder".localized(), text: $model.searchTerm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .height(20)
            }
        }
        .padding([.leading, .trailing, .top])
    }
    
    var switchView: some View {
        SegmentedPicker(
            selectedSegment: $model.selectedIndex,
            labels: model.tabs.map(\.title),
            markerHeight: 2
        )
            .height(34)
    }
    
    var invitationList: some View {
        PaginationList(model.invitationPaginator, placeholderBuilder: {
            InviteCell().asAnyView()
        }) {
            InvitationCell($0.asPublisher(in: .defaultStack))
                .asAnyView()
        }
    }
    
    var userList: some View {
        PaginationList(model.userPaginator) {
            UserCell($0.asPublisher(in: .defaultStack), selectionCommand: selectionCommand)
                .asAnyView()
        }
        .listRowInsets(EdgeInsets())
    }
    
    var placeList: some View {
        PaginationList(model.placePaginator) {
            PlaceCell($0.asPublisher(in: .defaultStack), selectionCommand: selectionCommand)
                .asAnyView()
        }
        .listRowInsets(EdgeInsets())
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}