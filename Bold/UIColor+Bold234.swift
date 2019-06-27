//
//  UIColor+Bold.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/28/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum ColorName {
        case typographyBlack100
        case typographyBlack75
        case typographyBlack50
        case typographyBlack25
        case primaryBlue
        case primaryOrange
        case primaryRed
        case secondaryPink
        case secondaryTurquoise
        case secondaryYellow
        case secondaryBlue
        
        var rgbaValue: UInt32 {
            switch self {
            case .typographyBlack100:
                return 0x1b2850ff
            case .typographyBlack75:
                return 0x495373ff
            case .typographyBlack50:
                return 0x767e96ff
            case .typographyBlack25:
                return 0x969cafff
            case .primaryBlue:
                return 0x456cdff
            case .primaryOrange:
                return 0xffaa6eff
            case .primaryRed:
                return 0xee6751ff
            case .secondaryPink:
                return 0xfb9d98ff
            case .secondaryTurquoise:
                return 0x43b3acff
            case .secondaryYellow:
                return 0xf3c32fff
            case .secondaryBlue:
                return 0x1c3aa7ff
            }
        }
        
        var color: UIColor {
            return UIColor(named: self)
        }
    }
}

extension UIColor {
    convenience init(named name: ColorName) {
        self.init(rgb: name.rgbaValue)
    }
}

extension UIColor {
    convenience init(rgb: UInt32) {
        let red   = CGFloat((rgb >> 24) & 0xff) / 255.0
        let green = CGFloat((rgb >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgb >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgb      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
