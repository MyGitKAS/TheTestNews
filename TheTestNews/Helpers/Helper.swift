//
//  Helper.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit


class Helper {
//    static func compress(image: UIImage) -> UIImage? {
//        let size = CGSize(width: 150, height: 100)
//        
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        image.draw(in: CGRect(origin: .zero, size: size))
//        
//        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return compressedImage
//    }
    
    static func resizeImage(_ image: UIImage?, to size: CGSize) -> UIImage? {
        guard let originalImage = image else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { context in
            originalImage.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }
}
