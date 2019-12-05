//
//  TableViewCellAnimationFactory.swift
//  Bold
//
//  Created by Admin on 02.12.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum TableViewCellAnimationFactory {
    static func moveUp(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> TableViewCellAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            
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
    
    static func slideIn(duration: TimeInterval, delayFactor: Double) -> TableViewCellAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            
            UIView.animate(withDuration: duration,
                           delay: delayFactor * Double(indexPath.row),
                           options: [.curveEaseInOut],
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
}
