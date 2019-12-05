//
//  TableViewCellAnimator.swift
//  Bold
//
//  Created by Admin on 02.12.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

typealias TableViewCellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

class TableViewCellAnimator {
    private let animation: TableViewCellAnimation
    
    init(animation: @escaping TableViewCellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        animation(cell, indexPath, tableView)
    }
    
}
