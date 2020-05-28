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
    
    func withColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(origin: .zero, size: self.size)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // convenience function in UIImage extension to resize a given image
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage
    {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return copied!
    }
    
}
