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
    func updateNameIdea(nameIdea: String)
    func editingName(name: String)
}

extension HeaderWriteActionsTableViewCellDelegate {
    func tapIdeas() {}
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
    
    func config(modelView: CreateGoalActionModel) {
        
        switch modelView.modelValue {
        case .header(let typeHeader, let nameString):
            nameActionsTextField.placeholder = typeHeader == .goal ? L10n.Act.Create.goalHeader : L10n.Act.Create.actionHeader
            ideasButton.isHidden = typeHeader == .action
            if let name = nameString {
                nameActionsTextField.text = name
            }
        default:
            return
        }
    }
    
    @IBAction func changedName(_ sender: UITextField) {
        delegate?.editingName(name: sender.text!)
    }
    
}

extension HeaderWriteActionsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateNameIdea(nameIdea: textField.text!)
    }
}
