//
//  addActionPlanViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit



enum addActionSettingsType {
    case header
    case duration
    case reminder
    case goal
    case stake
    case share
    
    func iconType() -> UIImage {
        switch self {
        case .duration:
            return Asset.addActionDuration.image
        case .reminder:
            return Asset.addActionReminder.image
        case .goal:
            return Asset.addActionGoal.image
        case .stake:
            return Asset.addActionStake.image
        case .share:
            return Asset.addActionShare.image
        default:
            return UIImage()
        }
    }
    
//    func textType() -> String {
//        <#function body#>
//    }
}

class addActionPlanViewController: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
