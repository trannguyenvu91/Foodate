// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

struct ASRemoteImageView: View
{
	init(_ url: URL)
	{
		self.url = url
		imageLoader = ASRemoteImageManager.shared.imageLoader(for: url)
	}

	let url: URL
	@ObservedObject var imageLoader: ASRemoteImageLoader

	var content: some View
	{
		ZStack
		{
			Color(.secondarySystemBackground)
			Image(systemName: "photo")
			self.imageLoader.image.map
			{ image in
				Image(uiImage: image)
					.resizable()
			}.transition(AnyTransition.opacity.animation(Animation.default))
		}
		.compositingGroup()
	}

	var body: some View
	{
		content
	}
}

extension ASRemoteImageView {
    
    init(path: String?) {
        if let path = path, let url = URL(string: path) {
            self.init(url)
        } else {
            let pathError = Bundle.main.path(forResource: "image-error", ofType: "png")
            self.init(URL(fileURLWithPath: pathError ?? ""))
        }
    }
    
}

extension ASRemoteImageManager {
    
    func load(path: String) {
        if let url = URL(string: path) {
            load(url)
        }
    }
    
}
