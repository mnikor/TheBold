//
//  UIImageView+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/18/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SDWebImage

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func downloadImageAnimated(path: String, placeholder: UIImage? = nil, forceFade: Bool = false, completion: ((UIImage?) -> Void)? = nil) {

        image = nil
        
        DispatchQueue.global(qos: .default).async {[weak self] in
            if let url = URL(string: path) {
                self?.setImageAnimated(path: path, url: url, placeholder: placeholder, forceFade: forceFade, completion: completion)
            } else {
                DispatchQueue.main.async {
                    self?.image = placeholder
                }
            }
        }
    }
    
    func setImageAnimated(path: String, url: URL?, placeholder: UIImage? = nil, forceFade: Bool = false, completion: ((UIImage?) -> Void)? = nil) {
        
        imageURLString = path
        
        if let image = NetworkService.shared.cacheImage(url: url) {
            DispatchQueue.main.async { [weak self] in
                guard let ss = self else { return }
                ss.image = image
            }
            completion?(image)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let ss = self else { return }
                ss.image = placeholder
            }
            SDWebImageManager.shared.loadImage(with: url,
                                               progress: nil) { [weak self] (image, data, error, cache, finished, url) in
                                                guard let ss = self else { return }
                                                if finished {
                                                    DispatchQueue.main.async {
                                                        if ss.imageURLString == path {
                                                            ss.image = image ?? placeholder
                                                        }
                                                    }
                                                    completion?(image)
                                                }
            }
        }
    }
    
}

extension UIImageView {
    
    func renderImageWithColor(image: UIImage, color: UIColor) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }

}
