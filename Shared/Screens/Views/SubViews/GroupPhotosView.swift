//
//  GroupPhotosView.swift
//  Foodate
//
//  Created by Vu Tran on 23/07/2021.
//

import SwiftUI

struct GroupPhotosView: View {
    let subCircleRatio: CGFloat = 0.6
    let borderWidth: CGFloat = 2
    let maxAvatar = 3
    
    var images: [String]
    init(_ images: [String]) {
        self.images = Array(images.prefix(maxAvatar))
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<images.count) { index in
                    HStack {
                        Spacer()
                            .frame(width: proxy.size.height * subCircleRatio * CGFloat(index))
                        circleView(images[index])
                            .frame(width: proxy.size.height)
                        Spacer()
                            .frame(width: proxy.size.height * subCircleRatio * CGFloat(images.count - 1 - index))
                    }
                }
            }
        }
        .scaledToFit()
    }
    
    func circleView(_ imageURL: String) -> some View {
            CircleView(
                ASRemoteImageView(path: imageURL)
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit),
                lineWidth: 2
            )
            .onAppear(perform: {
                ASRemoteImageManager.shared.load(path: imageURL)
            })
    }
    
    
    
}

struct GroupPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        GroupPhotosView([
            "https://photo2.tinhte.vn/data/attachment-files/2021/07/5559038_Tinhte_IPhone5.jpg",
            "https://photo2.tinhte.vn/data/attachment-files/2021/07/5559037_Tinhte_iPhone2.jpg"
            ])
        .frame(height: 100)
    }
}
