//
//  HeaderWriteActionsTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum HeaderCreateType {
    case goal
    case action
}

protocol HeaderWriteActionsTableViewCellDelegate: class {
    func tapIdeas()
}

class HeaderWriteActionsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameActionsTextField: UITextField!
    @IBOutlet weak var ideasButton: UIButton!
    
    weak var delegate: HeaderWriteActionsTableViewCellDelegate?
    
    @IBAction func tapIdeasButton(_ sender: UIButton) {
        delegate?.tapIdeas()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameActionsTextField.delegate = self
    }
    
    func config(typeHeader: HeaderCreateType) {
        
        nameActionsTextField.placeholder = typeHeader == .goal ? L10n.Act.Create.goalHeader : L10n.Act.Create.actionHeader
        ideasButton.isHidden = typeHeader == .action
        
    }
    
}

extension HeaderWriteActionsTableViewCell: UITextFieldDelegate {
    
    
    
}
