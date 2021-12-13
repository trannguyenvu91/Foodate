//
//  SearchType.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import Foundation

enum SearchType: Int, CaseIterable {
    case invitation = 0
    case account = 1
    case place = 2
    
    var title: String {
        switch self {
        case .account:
            return "SearchView_Account_Tab_Label".localized()
        case .place:
            return "SearchView_Place_Tab_Label".localized()
        case .invitation:
            return "SearchView_Invitation_Tab_Label".localized()
        }
    }
}
