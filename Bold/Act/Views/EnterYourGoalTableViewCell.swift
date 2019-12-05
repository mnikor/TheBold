//
//  EnterYourGoalTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/31/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol EnterYourGoalDelegate: class {
    func didChangeGoal(text: String)
}

class EnterYourGoalTableViewCell: BaseTableViewCell {
    
    weak var delegate: EnterYourGoalDelegate?

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
