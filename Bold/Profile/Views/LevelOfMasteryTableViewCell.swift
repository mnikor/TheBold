//
//  OpenedLevelOfMasteryTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {
    struct Color {
        static let defaultOuterColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        static let defaultInnerColor: UIColor = ColorName.primaryOrange.color
    }
    struct Size {
        static let lineWidthProgress: CGFloat = 2
    }
    struct Transform {
        static let cornerRadius: CGFloat = 6
    }
}

class LevelOfMasteryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var iconLevelImageView: UIImageView!
    @IBOutlet weak var titleLevelLabel: UILabel!
    
    @IBOutlet weak var check1ImageView: UIImageView!
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var check2ImageView: UIImageView!
    @IBOutlet weak var description2Label: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var checkLevelImageView: UIImageView!
    
    var progressRing: CircularProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        baseView.cornerRadius = Constants.Transform.cornerRadius
        configProgressCircle()
    }
    
    func configProgressCircle() {
        progressView.backgroundColor = .clear
        let xPosition = progressView.bounds.size.width / 2
        let yPosition = progressView.bounds.size.height / 2
        let position = CGPoint(x: xPosition, y: yPosition)
        let radius = min(progressView.bounds.size.height, progressView.bounds.size.width) / 2
        
        progressRing = CircularProgressBar(radius: radius, position: position, innerTrackColor: Constants.Color.defaultInnerColor, outerTrackColor: Constants.Color.defaultOuterColor, lineWidth: Constants.Size.lineWidthProgress, textFont: FontFamily.MontserratMedium.regular.font(size: 13), textColor: ColorName.typographyBlack100.color)
        progressView.layer.addSublayer(progressRing)
    }
    
    func config(level: LevelOfMasteryEntity) {
        
        ProgresOrLock(level: level)
        
        iconLevelImageView.image = level.type.iconImage
        titleLevelLabel.text = level.type.titleText
        
        guard let first = level.params.first else {
            return
        }
        
        checkParam(checkImageView: check1ImageView, descriptionLabel: description1Label, checkLevel: first)
        
        guard level.params.count == 2, let last = level.params.last else {
            checkParam(checkImageView: check2ImageView, descriptionLabel: description2Label, checkLevel: nil)
            return
        }
        checkParam(checkImageView: check2ImageView, descriptionLabel: description2Label, checkLevel: last)
    }
    
    func checkParam(checkImageView: UIImageView!, descriptionLabel: UILabel!, checkLevel: CheckLevelEntity?) {
        
        guard let checkLevel = checkLevel else {
            checkImageView.isHidden = true
            descriptionLabel.isHidden = true
            return
        }
        checkImageView.image = checkLevel.checkPoint == true ? Asset.checkIcon.image : Asset.checkDisableIcon.image
        descriptionLabel.text = checkLevel.titleText
    }
    
    func ProgresOrLock(level: LevelOfMasteryEntity) {
        progressView.isHidden = level.isLock
        lockImageView.isHidden = !level.isLock
        checkLevelImageView.isHidden = level.progress < 100
        if !level.isLock {
            self.progressRing.progress = CGFloat(level.progress)
        }
    }
}
