//
//  ForgotPasswordViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: LocalizableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendMeButton: UIButton!
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func localizeContent() {
        titleLabel.text = L10n.Authorization.forgotPassword
        subTitleLabel.text = L10n.Authorization.putYourEmailBelowAndWellSendYourPassword
        emailTextField.placeholder = L10n.Authorization.email
        sendMeButton.setTitle(L10n.Authorization.sendMePassword, for: .normal)
    }
    
    @IBAction func didTapAtSendMeButton(_ sender: RoundedButton) {
        NetworkService.shared.resetPassword(email: emailTextField.text ?? "")
    }
    
}
