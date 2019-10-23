//
//  UIImageView+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/18/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SDWebImage


extension UIImageView {
    
    func renderImageWithColor(image: UIImage, color: UIColor) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }

    func setImageAnimated(path: String, placeholder: UIImage? = nil, forceFade: Bool = false) {
        if let url = URL(string: path) {
            setImageAnimated(url: url, placeholder: placeholder, forceFade: forceFade)
        } else {
            image = placeholder
        }
    }
    
    func setImageAnimated(url: URL?, placeholder: UIImage? = nil, forceFade: Bool = false) {
        let theBoldCache = SDImageCache(namespace: "theBold")
        theBoldCache.config.maxDiskAge = 2678400
        theBoldCache.config.shouldCacheImagesInMemory = true
        SDImageCachesManager.shared.caches = [theBoldCache]
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
        let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
        if let image = theBoldCache.imageFromCache(forKey: cacheKey) {
            self.image = image
        } else {
            image = placeholder
            SDWebImageManager.shared.loadImage(with: url,
                                               progress: nil) { [weak self] (image, data, error, cache, finished, url) in
                                                guard let self = self else { return }
                                                if finished,
                                                    image != nil {
                                                    self.image = image
                                                }
            }
        }
    }
}
