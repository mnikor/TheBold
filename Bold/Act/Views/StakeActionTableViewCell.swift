//
//  StakeActionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol StakeActionTableViewCellDelegate: class {
    func tapLongPress(event: Event)
}

class StakeActionTableViewCell: BaseTableViewCell {

    @IBOutlet weak var contentActionView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var stakeLabel: UILabel!
    @IBOutlet weak var pointsActivityLabel: UILabel!
    @IBOutlet weak var shapeImageView: UIImageView!
    
    @IBOutlet weak var stakeStackView: UIStackView!
    
    weak var delegate: StakeActionTableViewCellDelegate?
    private var event: Event!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addLongTapRecognizer()
    }
    
    private func addLongTapRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(activeLongPress(gesture:)))
        longPress.minimumPressDuration = 1.0
        longPress.delegate = self
        contentActionView.addGestureRecognizer(longPress)
    }
    
    @objc private func activeLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("Long press")
            delegate?.tapLongPress(event: event)
        }
    }
    
    func config(viewModel: CalendarModelType) {
        if case .event(viewModel: let cellModel) = viewModel {
            event = cellModel.event
            
            setupAttributedTitle(for: cellModel)
            
            statusImageView.renderImageWithColor(image: cellModel.statusIcon, color: cellModel.statusIconColor)
            subtitleLabel.text          = cellModel.contentName
            subtitleLabel.isHidden      = cellModel.contentNameIsHidden
            stakeLabel.text             = cellModel.stake
            stakeLabel.textColor        = cellModel.stakeColor
            pointsActivityLabel.text    = cellModel.points
        }
    }
 
    private func setupAttributedTitle(for cellModel: StakeActionViewModel) {
        
        titleLabel.attributedText = cellModel.title
        
        if event.status == StatusType.completed.rawValue {
            if let nameTitle = event.name {
                let title = NSMutableAttributedString(string: nameTitle)
                title.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, title.length))
                titleLabel.attributedText = title
            }
        }
        
    }
    
}
