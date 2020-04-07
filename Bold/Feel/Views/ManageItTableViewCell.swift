//
//  ManageItTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum TypeManageItCell {
    case titleAndScroll
    case baseStaticCells
}

private struct Constants{
    
    struct ColectionView {
        static let heightOneCell: CGFloat = 120
        static let paddingStaticCells: CGFloat = 16*2
        static let paddingTitleAndScroll: CGFloat = 30
    }
    
    struct Inset {
        static let leftRightStaticCells: CGFloat = 16
        static let leftRightTitleAndScroll: CGFloat = 20
    }
}

protocol ManageItTableViewCellDelegate: class {
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent)
}

class ManageItTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    
    weak var delegate: ManageItTableViewCellDelegate?
    
    var type : TypeManageItCell!
    var group: ActivityGroup!
    var actions: [ActivityContent] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerXibs()
    }
    
    func registerXibs() {
        collectionView.registerNib(ListenOrReadMaterialCollectionViewCell.self)
    }
    
    func config(type: TypeManageItCell, group: ActivityGroup?) {
        
        guard let group = group else { return }
        self.group = group
        
        
        if group.contentObjects.count == 4 || group.contentObjects.count == 2 {
            heightCollectionConstraint.constant = Constants.ColectionView.heightOneCell * 2
        }else {
            heightCollectionConstraint.constant = Constants.ColectionView.heightOneCell * 3
        }
        
        titleLabel.text = group.name
        
        self.type = type
        switch type {
        case .titleAndScroll:
            collectionView.isScrollEnabled = true
            titleLabel.isHidden = false
            headTitleConstraint.constant = 30
        case .baseStaticCells:
            collectionView.isScrollEnabled = false
            titleLabel.isHidden = true
            headTitleConstraint.constant = 0
        }
        
        actions =  group.contentObjects
        
        collectionView.reloadData()
    }
}


extension ManageItTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ListenOrReadMaterialCollectionViewCell
        cell.config(content: actions[indexPath.row], type: .unlockListenPreview)
        cell.delegate = self
        return cell
    }
}

extension ManageItTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = self.type == .baseStaticCells ? Constants.ColectionView.paddingStaticCells : Constants.ColectionView.paddingTitleAndScroll
        return CGSize(width: self.contentView.bounds.width - padding, height: Constants.ColectionView.heightOneCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = self.type == .baseStaticCells ? Constants.Inset.leftRightStaticCells : Constants.Inset.leftRightTitleAndScroll
        return UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
    }
}

extension ManageItTableViewCell: ListenOrReadMaterialCollectionViewCellDelegate {
    
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent) {
        delegate?.tapButton(buttonType: buttonType, content: content)
    }
}
