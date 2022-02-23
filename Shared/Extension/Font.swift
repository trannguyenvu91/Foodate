//
//  Font.swift
//  Foodate
//
//  Created by Vu Tran on 05/08/2021.
//

import SwiftUI

extension Font {
    
    public func getTextStyle() -> TextStyle? {
        switch self {
            case .largeTitle:
                return .largeTitle
            case .title:
                return .title
            case .headline:
                return .headline
            case .subheadline:
                return .subheadline
            case .body:
                return .body
            case .callout:
                return .callout
            case .footnote:
                return .footnote
            case .caption:
                return .caption
            default:
                return nil
        }
    }
    
    #if canImport(UIKit)
    public func toUIFont() -> UIFont? {
        guard let textStyle = getTextStyle()?.toUIFontTextStyle() else {
            return nil
        }
        
        return .preferredFont(forTextStyle: textStyle)
    }
    #endif
}


extension Font.TextStyle {
    public func toUIFontTextStyle() -> UIFont.TextStyle? {
        switch self {
            #if !os(tvOS)
            case .largeTitle:
                return .largeTitle
            #endif
            case .title:
                return .title1
            case .headline:
                return .headline
            case .subheadline:
                return .subheadline
            case .body:
                return .body
            case .callout:
                return .callout
            case .footnote:
                return .footnote
            case .caption:
                return .caption1
                
            default: do {
                if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                    switch self {
                        case .title2:
                            return .title2
                        case .title3:
                            return .title3
                        case .caption2:
                            return .caption2
                        default: do {
                            assertionFailure()
                            
                            return .body
                        }
                    }
                } else {
                    assertionFailure()
                    
                    return .body
                }
            }
        }
    }
}
