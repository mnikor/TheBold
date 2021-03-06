//
//  ColorListCreateGoalTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ColorGoalType {
    case orange
    case red
    case blueDark
    case green
    case yellow
    case blue
    case none
    
    func colorGoal() -> UIColor {
        switch self {
        case .orange:
            return ColorName.primaryOrange.color
        case .red:
            return ColorName.primaryRed.color
        case .blueDark:
            return ColorName.secondaryBlue.color
        case .green:
            return ColorName.secondaryTurquoise.color
        case .yellow:
            return ColorName.secondaryYellow.color
        case .blue:
            return ColorName.primaryBlue.color
        default:
            return .white
        }
    }
}

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
    
    lazy var colors : [ColorGoalType] = {
        return [.orange, .red, .blueDark, .green, .yellow, .blue]
    }()
    
    var currentColor: ColorGoalType = .orange
    
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
    
    func config(currentColor: ColorGoalType) {
        self.currentColor = currentColor
        collectionView.reloadData()
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
