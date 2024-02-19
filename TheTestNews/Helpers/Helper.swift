//
//  Helper.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit


class Helper {
    
    static func downloadImageWith(url: String?, completion: @escaping (UIImage?) -> Void) {
        if let imageUrl = URL(string: url ?? "") {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(UIImage(named: "test_image"))
                    return
                }
                
                let compressedImage = compress(image: image)
                completion(compressedImage)
            }.resume()
        } else {
            completion(UIImage(named: "test_image"))
        }
    }
    
    static func compress(image: UIImage) -> UIImage? {
        let size = CGSize(width: 130, height: 200)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compressedImage
    }
}

