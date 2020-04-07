//
//  ListenOrReadMaterialCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ListenOrReadMaterialCollectionViewCellDelegate: class {
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent)
}

class ListenOrReadMaterialCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var listenOrReadView: ListenOrReadMaterialView!
    
    weak var delegate: ListenOrReadMaterialCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listenOrReadView.delegate = self
        
    }
    
    func config(content: ActivityContent, type: ListenOrReadCellType) {
        listenOrReadView.config(content: content, type: type)
    }
}

extension ListenOrReadMaterialCollectionViewCell: ListenOrReadMaterialViewDelegate {
    
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent) {
        delegate?.tapButton(buttonType: buttonType, content: content)
    }
    
}
