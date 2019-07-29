//
//  ColorCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        colorView.layer.cornerRadius = colorView.bounds.size.height / 2
        layer.cornerRadius = bounds.size.height / 2
    }
    
    func config(item: ColorGoalType, selectColor:ColorGoalType) {
        
        colorView.backgroundColor = item.colorGoal()
        if (item == selectColor) {
            addShadow(color: item.colorGoal())
        }else {
            removeShadow()
        }
    }

    func addShadow(color: UIColor)  {
        let layerCell = colorView.layer
        layerCell.cornerRadius = 11
        layerCell.shadowPath = nil
        layerCell.shadowColor = color.cgColor
        layerCell.shadowRadius = 4
        layerCell.shadowOpacity = 1
        layerCell.shadowOffset = .zero
    }
    
    func removeShadow() {
        let layerCell = colorView.layer
        layerCell.cornerRadius = 0
        layerCell.shadowPath = nil
        layerCell.shadowColor = UIColor.clear.cgColor
        layerCell.shadowRadius = 0
        layerCell.shadowOpacity = 0
        layerCell.shadowOffset = .zero
    }
}
