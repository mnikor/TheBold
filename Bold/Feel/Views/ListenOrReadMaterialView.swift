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

enum GroupContentButtonPressType {
    case unlock
    case start
    case addToPlan
    case previewListen
    case previewRead
}

protocol ListenOrReadMaterialViewDelegate: class {
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent)
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
    var content: ActivityContent!
    
    @IBAction func tapStartButton(_ sender: UIButton) {
        delegate?.tapButton(buttonType: .start, content: content)
    }
    
    @IBAction func tapUnlockButton(_ sender: UIButton) {
        delegate?.tapButton(buttonType: .unlock, content: content)
    }
    
    @IBAction func tapAddPlanButton(_ sender: UIButton) {
        delegate?.tapButton(buttonType: .addToPlan, content: content)
    }
    
    @IBAction func tapListenPreviewButton(_ sender: UIButton) {
        delegate?.tapButton(buttonType: .previewListen, content: content)
    }
    
    @IBAction func tapReadPreviewButton(_ sender: UIButton) {
        delegate?.tapButton(buttonType: .previewRead, content: content)
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
    
    func config(content: ActivityContent, type: ListenOrReadCellType) {
        
        var durationDescription = ""
        var typeTemp = ListenOrReadCellType.startAddToPlan
        
        switch content.type {
        case .meditation, .hypnosis, .preptalk:
            typeTemp = content.contentStatus == .locked ? .unlockListenPreview : .startAddToPlan
            durationDescription = " listen"
        case .lesson, .story:
            typeTemp = content.contentStatus == .locked ? .unlockReadPreview : .startAddToPlan
            durationDescription = " read"
        default:
            break
        }
        
        titleLabel.text = content.title
        if content.durtionRead != 0 {
            durationLabel.text = ("\(content.durtionRead) min") + durationDescription
        }
        iconImageView.setImageAnimated(path: content.smallImageURL ?? "", placeholder: Asset.actionBackground.image)
        
        self.content = content
//        self.typeView = type
        
        switch typeTemp {
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
