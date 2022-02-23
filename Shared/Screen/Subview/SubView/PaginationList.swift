//
//  PaginationList.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import SwiftUI
import Combine

struct PaginationList<Model, Content, PlaceHolder>: View where Model: Hashable & Equatable & ImportableJSONObject, Content: View, PlaceHolder: View {
    
    @ObservedObject var paginator: Paginator<Model>
    var cellBuilder: (Model) -> Content
    var placeholderBuilder: (() -> PlaceHolder)?
    
    init(_ paginator: Paginator<Model>,
         placeholderBuilder: (() -> PlaceHolder)? = nil,
         cellBuilder: @escaping (Model) -> Content
    ) {
        self.paginator = paginator
        self.cellBuilder = cellBuilder
        self.placeholderBuilder = placeholderBuilder
    }
    
    @ViewBuilder
    var body: some View {
        if let error = paginator.error {
            ErrorView(error: error)
        } else if !paginator.hasNext && paginator.items.count == 0 {
            placeholderBuilder?()
        } else {
            list
                .taskOnLoad(error: $paginator.error) {
                    try await paginator.fetchNext()
                }
        }
    }
    
    @ViewBuilder
    var list: some View {
        if paginator.isFetching {
            loadingCell
        }
        ForEach(paginator.items, id: \.self) {
            cellBuilder($0)
        }
        if paginator.hasNext {
            loadingCell.taskOnAppear(error: $paginator.error) {
                try await paginator.fetchNext()
            }
        } else {
            EndResultView()
        }
    }
    
    var loadingCell: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
}

struct PaginationList_Previews: PreviewProvider {
    static var previews: some View {
        PaginationList(SearchProfilePaginator(nil), placeholderBuilder: { EmptyView() }) {
            UserCell($0.asPublisher(in: .defaultStack))
        }
    }
}
