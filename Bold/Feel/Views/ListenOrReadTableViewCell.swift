//
//  ListenOrReadTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ListenOrReadTableViewCellDelegate: class {
    func tapBlueButtonInTableCell(type: ListenOrReadCellType)
    func tapClearButtonInTableCell(type: ListenOrReadCellType)
}

class ListenOrReadTableViewCell: BaseTableViewCell {

   @IBOutlet weak var listenOrReadView: ListenOrReadMaterialView!
    
    weak var delegate: ListenOrReadTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listenOrReadView.delegate = self
    }

    func config(type: ListenOrReadCellType) {
        listenOrReadView.config(type: type)
    }
}

extension ListenOrReadTableViewCell: ListenOrReadMaterialViewDelegate {
    func tapBlueButton(type: ListenOrReadCellType) {
        delegate?.tapBlueButtonInTableCell(type: type)
    }
    
    func tapClearButton(type: ListenOrReadCellType) {
        delegate?.tapClearButtonInTableCell(type: type)
    }
    
//    func tapBlueButton() {
//        delegate?.tapUnlock()
//    }
//    
//    func tapClearButton() {
//        delegate?.tapPreview()
//    }
}
