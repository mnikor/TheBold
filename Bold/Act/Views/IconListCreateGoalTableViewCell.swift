//
//  IconListCreateGoalTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {
    struct SizeCell {
        static let size : CGSize = CGSize(width: 50, height: 50)
    }
    struct Insets {
        static let topBottomIndentCell : CGFloat = 18
        static let rightLeftIndentCell : CGFloat = 25
    }
    struct Spacing {
        static let section : CGFloat = 10
    }
    struct VisibleElement {
        static let inSectionCount : CGFloat = 4
    }
}

protocol IconListCreateGoalTableViewCellDelegate: class {
    func tapSelectIcon(selectIcon: IdeasType)
}

class IconListCreateGoalTableViewCell: BaseTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: IconListCreateGoalTableViewCellDelegate?
    
    var icons : [IdeasType]!
    var currentColor: ColorGoalType = .none
    var currentIcon : IdeasType = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        registerXibs()
    }
    
    func registerXibs() {
        collectionView.registerNib(IconCollectionViewCell.self)
    }
    
    func config(modelView: CreateGoalModel) {
        
        switch modelView.modelValue {
        case .icons(let icons, let selectIcon, let selectColor):
            self.icons = icons
            self.currentIcon = selectIcon
            self.currentColor = selectColor
            collectionView.reloadData()
        default:
            return
        }
    }
}


    // MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension IconListCreateGoalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as IconCollectionViewCell
        cell.config(iconType: icons[indexPath.row], selectIcon: currentIcon, color: currentColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.tapSelectIcon(selectIcon: icons[indexPath.row])
    }
    
}


    // MARK:- UICollectionViewDelegateFlowLayout

extension IconListCreateGoalTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.SizeCell.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.topBottomIndentCell,
                            left: Constants.Insets.rightLeftIndentCell,
                            bottom: Constants.Insets.topBottomIndentCell,
                            right: Constants.Insets.rightLeftIndentCell)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let widthSpaceAll = collectionView.bounds.size.width - Constants.Insets.rightLeftIndentCell * 2 - Constants.SizeCell.size.width * Constants.VisibleElement.inSectionCount
        return widthSpaceAll / (Constants.VisibleElement.inSectionCount - 1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.section
    }

}
