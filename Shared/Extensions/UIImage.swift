//
//  UIImage+Helpers.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/27/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import UIKit

extension UIImage {
    
    func generateData(with meta: JSON) -> Data? {
        guard let jpgData = jpegData(compressionQuality: 1) else { return nil}
        // Add metadata to jpgData
        guard let source = CGImageSourceCreateWithData(jpgData as CFData, nil),
            let uniformTypeIdentifier = CGImageSourceGetType(source) else { return jpgData}
        let finalData = NSMutableData(data: jpgData)
        guard let destination = CGImageDestinationCreateWithData(finalData, uniformTypeIdentifier, 1, nil) else { return jpgData
        }
        CGImageDestinationAddImageFromSource(destination, source, 0, meta as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { return jpgData}
        
        return finalData as Data
    }
    
     func resize(to targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
}
