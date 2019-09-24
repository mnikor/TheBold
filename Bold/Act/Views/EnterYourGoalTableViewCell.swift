//
//  EnterYourGoalTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/31/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class EnterYourGoalTableViewCell: BaseTableViewCell {

    @IBOutlet weak var goalNameTextField : UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(modelView: ConfigureActionModelType) {
        
        if case .createNewGoal(placeholder: let placeholder) = modelView {
            goalNameTextField.placeholder = placeholder
        }
    }
    
}
