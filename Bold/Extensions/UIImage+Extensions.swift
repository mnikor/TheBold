//
//  UIImage+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/18/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func image(size: CGSize, fillColors: [UIColor] = [.clear]) -> UIImage? {
        
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0.75)
        backgroundLayer.endPoint = CGPoint(x: 0, y: 1)
        
        var fillColorsArray: [CGColor] = fillColors.map {$0.cgColor}
        
        if fillColorsArray.count == 1 {
            fillColorsArray.append(fillColorsArray.first!)
        }
        backgroundLayer.colors = fillColorsArray
        
        guard let image = UIImage.image(from: backgroundLayer) else {
            return nil
        }
        return image
    }
    
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
