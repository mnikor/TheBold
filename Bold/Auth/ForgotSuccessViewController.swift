//
//  ForgotSuccessViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ForgotSuccessViewController: LocalizableViewController {
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var passwordSendLabel: UILabel!
    @IBOutlet weak var logInNowButton: RoundedButton!
    
    @IBAction func tapLogInNow(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func localizeContent() {
        successLabel.text = L10n.Authorization.success
        passwordSendLabel.text = L10n.Authorization.yourPasswordWasSend
        logInNowButton.setTitle(L10n.Authorization.logInNow, for: .normal)
    }

}
