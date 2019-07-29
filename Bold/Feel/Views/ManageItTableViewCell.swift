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
    case baseThreeCells
}

protocol ManageItTableViewCellDelegate: class {
    func tapBlueButton(type: ListenOrReadCellType)
    func tapCleanButton(type: ListenOrReadCellType)
}

class ManageItTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headTitleConstraint: NSLayoutConstraint!
    
    weak var delegate: ManageItTableViewCellDelegate?
    
    var type : TypeManageItCell!
    
    
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
    
    func config(type: TypeManageItCell) {
        self.type = type
        switch type {
        case .titleAndScroll:
            collectionView.isScrollEnabled = true
            titleLabel.isHidden = false
            headTitleConstraint.constant = 30
        case .baseThreeCells:
            collectionView.isScrollEnabled = false
            titleLabel.isHidden = true
            headTitleConstraint.constant = 0
        }
        collectionView.reloadData()
    }
}


extension ManageItTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.type == .baseThreeCells ? 3 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ListenOrReadMaterialCollectionViewCell
        cell.config(type: .unlockListenPreview)
        cell.delegate = self
        return cell
    }
}

extension ManageItTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = self.type == .baseThreeCells ? 16*2 : 30
        return CGSize(width: self.contentView.bounds.width - padding, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = self.type == .baseThreeCells ? 16 : 20
        return UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
    }
}

extension ManageItTableViewCell: ListenOrReadMaterialCollectionViewCellDelegate {
    func tapBlueButtonInCollectionCell(type: ListenOrReadCellType) {
        delegate?.tapBlueButton(type: type)
    }
    
    func tapClearButtonInCollectionCell(type: ListenOrReadCellType) {
        delegate?.tapCleanButton(type: type)
    }
    
//    func tapUnlock() {
//        print("tap Unlock")
//    }
//
//    func tapPreview() {
//        print("tap Preview")
//    }
}
