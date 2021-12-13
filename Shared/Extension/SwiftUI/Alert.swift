//
//  Alert.swift
//  Foodate
//
//  Created by Vu Tran on 16/07/2021.
//

import SwiftUI

extension Alert {
    init(error: Error?) {
        let message = error?.alertMessage ?? ""
        self.init(title: Text("Error"),
                  message: Text(message),
                  dismissButton: .cancel(Text("Ok")))
    }
}
