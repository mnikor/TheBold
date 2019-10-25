//
//  HeaderTitleActionPlanTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol HeaderTitleActionPlanTableViewCellDelegate: class {
    func updateNameAction(newName: String)
    func editingName(name: String)
    func changeEditAction()
}

class HeaderTitleActionPlanTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editTextButton: UIButton!
    
    weak var delegate: HeaderTitleActionPlanTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleTextField.delegate = self
    }

    func config(modelView: CreateGoalActionModel) {
    
        if case .headerEdit(statusEdit: let isEditAction, name: let nameString) = modelView.modelValue {
            titleTextField.text = nameString
            titleTextField.isEnabled = isEditAction
            editTextButton.setImage(isEditAction == false ? Asset.editDisableIcon.image : Asset.editEnableIcon.image, for: .normal)
        }
    }
    
    @IBAction func changedName(_ sender: UITextField) {
        delegate?.editingName(name: sender.text!)
    }
    
    @IBAction func tapEditAction(_ sender: UIButton) {
        delegate?.changeEditAction()
    }
    
}

extension HeaderTitleActionPlanTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateNameAction(newName: textField.text!)
    }
}
