//
//  ListenOrReadMaterialView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ListenOrReadCellType {
    case unlockListenPreview
    case unlockReadPreview
    case startAddToPlan
}

protocol ListenOrReadMaterialViewDelegate: class {
    func tapBlueButton(type: ListenOrReadCellType)
    func tapClearButton(type: ListenOrReadCellType)
}

class ListenOrReadMaterialView: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var addPlanButton: UIButton!
    @IBOutlet weak var listenPreviewButton: UIButton!
    @IBOutlet weak var readPreviewButton: UIButton!
    
    weak var delegate: ListenOrReadMaterialViewDelegate?
    var typeView: ListenOrReadCellType!
    
    @IBAction func tapStartButton(_ sender: UIButton) {
        delegate?.tapBlueButton(type: typeView)
    }
    
    @IBAction func tapUnlockButton(_ sender: UIButton) {
        delegate?.tapBlueButton(type: typeView)
    }
    
    @IBAction func tapAddPlanButton(_ sender: UIButton) {
        delegate?.tapClearButton(type: typeView)
    }
    
    @IBAction func tapListenPreviewButton(_ sender: UIButton) {
        delegate?.tapClearButton(type: typeView)
    }
    
    @IBAction func tapReadPreviewButton(_ sender: UIButton) {
        delegate?.tapClearButton(type: typeView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ListenOrReadMaterialView", owner: self)
        contentView.fixInView(self)
        backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func config(type: ListenOrReadCellType) {
        self.typeView = type
        switch type {
        case .unlockListenPreview:
            durationLabel.isHidden = false
            startButton.isHidden = true
            unlockButton.isHidden = false
            addPlanButton.isHidden = true
            listenPreviewButton.isHidden = false
            readPreviewButton.isHidden = true
            unlockButton.positionImageBeforeText(padding: 8)
        case .unlockReadPreview:
            durationLabel.isHidden = false
            startButton.isHidden = true
            unlockButton.isHidden = false
            addPlanButton.isHidden = true
            listenPreviewButton.isHidden = true
            readPreviewButton.isHidden = false
            unlockButton.positionImageBeforeText(padding: 8)
        case .startAddToPlan:
            durationLabel.isHidden = true
            startButton.isHidden = false
            unlockButton.isHidden = true
            addPlanButton.isHidden = false
            listenPreviewButton.isHidden = true
            readPreviewButton.isHidden = true
            addPlanButton.positionImageBeforeText(padding: 8)
        }
    }
}
