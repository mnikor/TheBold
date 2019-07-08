//
//  BaseTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell, Reusable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionStyle = .none
    }
}

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable  {

}

class BaseCollectionViewCell: UICollectionViewCell, Reusable {

}

class BaseCollectionReusableView: UICollectionReusableView, Reusable {

}
