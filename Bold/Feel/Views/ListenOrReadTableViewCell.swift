//
//  ListenOrReadTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ListenOrReadTableViewCellDelegate: class {
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent)
}

class ListenOrReadTableViewCell: BaseTableViewCell {

   @IBOutlet weak var listenOrReadView: ListenOrReadMaterialView!
    
    weak var delegate: ListenOrReadTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listenOrReadView.delegate = self
    }

    func config(content: ActivityContent, type: ListenOrReadCellType) {
        listenOrReadView.config(content: content, type: type)
    }
}

extension ListenOrReadTableViewCell: ListenOrReadMaterialViewDelegate {
    
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent) {
        delegate?.tapButton(buttonType: buttonType, content: content)
    }
    
}
