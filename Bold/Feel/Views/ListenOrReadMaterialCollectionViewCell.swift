//
//  ListenOrReadMaterialCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ListenOrReadMaterialCollectionViewCellDelegate: class {
    func tapBlueButtonInCollectionCell(type: ListenOrReadCellType)
    func tapClearButtonInCollectionCell(type: ListenOrReadCellType)
}

class ListenOrReadMaterialCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var listenOrReadView: ListenOrReadMaterialView!
    
    weak var delegate: ListenOrReadMaterialCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listenOrReadView.delegate = self
        
    }
    
    func config(type: ListenOrReadCellType) {
        listenOrReadView.config(type: type)
    }
}

extension ListenOrReadMaterialCollectionViewCell: ListenOrReadMaterialViewDelegate {
    func tapBlueButton(type: ListenOrReadCellType) {
        delegate?.tapBlueButtonInCollectionCell(type: type)
    }
    
    func tapClearButton(type: ListenOrReadCellType) {
        delegate?.tapClearButtonInCollectionCell(type: type)
    }
    
//    func tapBlueButton() {
//        delegate?.tapUnlock()
//    }
//    
//    func tapClearButton() {
//        delegate?.tapPreview()
//    }
}
