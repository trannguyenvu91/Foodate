//
//  PaginationList.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import SwiftUI
import Combine

struct PaginationList<Model>: View where Model: Hashable & Equatable & ImportableJSONObject {
    
    @ObservedObject var paginator: Paginator<Model>
    var cellBuilder: (Model) -> AnyView
    var placeholderBuilder: (() -> AnyView)?
    @State var error: Error?
    
    init(_ paginator: Paginator<Model>,
         placeholderBuilder: (() -> AnyView)? = nil,
         cellBuilder: @escaping (Model) -> AnyView
    ) {
        self.paginator = paginator
        self.cellBuilder = cellBuilder
        self.placeholderBuilder = placeholderBuilder
    }
    
    var body: some View {
        VStack {
            if let error = error {
                Text("Error happened: \(error.alertMessage)")
            } else if !paginator.hasNext && paginator.items.count == 0 {
                placeholderBuilder?()
            } else {
                list
                if !paginator.hasNext {
                    EndResultView()
                }
            }
        }
        .onLoad {
            Task {
                do {
                    try await paginator.fetchNext()
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    var list: AnyView {
        if paginator.isFetching {
            return HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .asAnyView()
        }
        return ForEach(paginator.items, id: \.self) {
            cellBuilder($0)
        }
        .asAnyView()
    }
    
}

struct PaginationList_Previews: PreviewProvider {
    static var previews: some View {
        PaginationList(SearchProfilePaginator(nil)) {
            UserCell($0.asPublisher(in: .defaultStack))
                .asAnyView()
        }
    }
}
