//
//  PhotosPageView.swift
//  Foodate
//
//  Created by Vu Tran on 16/07/2021.
//

import SwiftUI
import CoreStore

struct PhotosPageView<T: FDBasePhoto>: View {
    var photos: [ObjectPublisher<T>]
    
    init(_ photos: [ObjectPublisher<T>]) {
        self.photos = photos
    }
    
    var body: some View {
        GeometryReader { proxy in
            TabView {
                ForEach(photos, id: \.self) { photo in
                    ObjectReader(photo) { snapshot in
                        ASRemoteImageView(path: snapshot.$baseURL)
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.width)
                            .cornerRadius(0)
                            .onAppear {
                                guard let url = try? snapshot.$baseURL?.asURL() else { return }
                                ASRemoteImageManager.shared.load(url)
                            }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct PhotosPageView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosPageView([])
    }
}
