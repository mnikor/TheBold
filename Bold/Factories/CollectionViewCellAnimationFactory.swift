//
//  CollectionViewCellAnimationFactory.swift
//  Bold
//
//  Created by Admin on 02.12.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum CollectionViewCellAnimationFactory {
    static func moveIn(cellWidth: CGFloat, duration: TimeInterval, delayFactor: Double) -> CollectionViewCellAnimation {
        return { cell, indexPath, collectionView in
            cell.transform = CGAffineTransform(translationX: cellWidth, y: 0)
            
            UIView.animate(withDuration: duration,
                           delay: delayFactor * Double(indexPath.row),
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut],
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
}
