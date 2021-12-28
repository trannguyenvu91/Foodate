//
//  SegmentedPicker.swift
//  SegmentedPicker
//
//  Created by Antonio Nunes on 04/07/2020.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this source code and associated documentation files (the "SourceCode"), to deal
//  in the SourceCode without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute copies of the SourceCode, and to
//  sell software using the SourceCode, and permit persons to whom the SourceCode is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the SourceCode.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import SwiftUI

struct ButtonPreferenceData {
    let viewIdx: Int
    var bounds: Anchor<CGRect>
}

struct ButtonPreferenceKey: PreferenceKey {
    static var defaultValue: [ButtonPreferenceData] = []

    static func reduce(value: inout [ButtonPreferenceData], nextValue: () -> [ButtonPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PickerButton: View {
    var index: Int
    let title: String
    @Binding var selectedButtonIndex: Int

    var body: some View {
        Button(action: {
            selectedButtonIndex = index
        }) {
            Text(title)
                .fontWeight(index == selectedButtonIndex ? .semibold : .regular)
                .fixedSize()
                .foregroundColor(index == selectedButtonIndex ? .black : .gray)
        }
        .padding(10)
        .anchorPreference(key: ButtonPreferenceKey.self, value: .bounds, transform: {
            [ButtonPreferenceData(viewIdx: index, bounds: $0)]
        })
        .buttonStyle(.plain)
    }
}

struct SegmentedPicker: View {
    @State private var allFit: Bool = true

    @Binding var selectedSegment: Int
    var labels: [String]
    var markerHeight: CGFloat = 6

    var body: some View {
        GeometryReader { stackProxy in
            appropriateView(stackProxy: stackProxy)
        }
    }

    private func appropriateView(stackProxy: GeometryProxy) -> some View {
        return AnyView(regularView(stackProxy: stackProxy))
    }

    private func regularView(stackProxy: GeometryProxy) -> some View {
        return HStack {
            ForEach(0 ..< labels.count, id: \.self) {
                PickerButton(index: $0, title: labels[$0], selectedButtonIndex: $selectedSegment)
            }
        }
        .frame(width: stackProxy.size.width, height: stackProxy.size.height, alignment: .center)
        .backgroundPreferenceValue(ButtonPreferenceKey.self) { preferences in
            processPreferenceValue(containerGeometry: stackProxy, preferences: preferences)
        }
    }
    
    private func processPreferenceValue(containerGeometry: GeometryProxy, preferences: [ButtonPreferenceData]) -> some View {
        return
            showSelectionIndicator(containerGeometry: containerGeometry, preferences: preferences)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private func showSelectionIndicator(containerGeometry: GeometryProxy, preferences: [ButtonPreferenceData]) -> some View {
        if let preference = preferences.first(where: { $0.viewIdx == self.selectedSegment }) {
            let anchorBounds = preference.bounds
            let bounds = containerGeometry[anchorBounds]
            return AnyView(RoundedRectangle(cornerRadius: markerHeight / 2)
                            .fill()
                            .foregroundColor(Color.black)
                            .frame(width: bounds.width, height: markerHeight)
                            .fixedSize()
                            .offset(x: bounds.minX, y: bounds.maxY)
                            .animation(.easeInOut(duration: 0.33), value: 1))
        } else {
            return AnyView(EmptyView())
        }
    }

}
