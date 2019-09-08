//
//  ColorListCreateGoalTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {
    struct SizeCell {
        static let size : CGSize = CGSize(width: 30, height: 30)
    }
    struct Insets {
        static let topBottomIndentCell : CGFloat = 0
        static let rightLeftIndentCell : CGFloat = 33
    }
}

protocol ColorListCreateGoalTableViewCellDelegate: class {
    func tapSelectColor(colorType: ColorGoalType)
}

class ColorListCreateGoalTableViewCell: BaseTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ColorListCreateGoalTableViewCellDelegate?
    
    var colors = [ColorGoalType]()
    var currentColor : ColorGoalType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerXibs()
    }

    func registerXibs() {
        collectionView.registerNib(ColorCollectionViewCell.self)
    }
    
    func config(modelView: CreateGoalModel) {
        
        switch modelView.modelValue {
        case .colors(let colorList, let selectColor):
            self.colors = colorList
            self.currentColor = selectColor
            collectionView.reloadData()
        default:
            return
        }
    }
}

extension ColorListCreateGoalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ColorCollectionViewCell
        cell.config(item: colors[indexPath.row], selectColor: currentColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.tapSelectColor(colorType: colors[indexPath.row])
    }
    
}

extension ColorListCreateGoalTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.SizeCell.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.topBottomIndentCell,
                            left: Constants.Insets.rightLeftIndentCell,
                            bottom: 0,
                            right: Constants.Insets.rightLeftIndentCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let widthSpaceAll = collectionView.bounds.size.width - Constants.Insets.rightLeftIndentCell * 2 - Constants.SizeCell.size.width * CGFloat(colors.count)
        return widthSpaceAll / CGFloat(colors.count - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.bounds.size.height
    }

}
