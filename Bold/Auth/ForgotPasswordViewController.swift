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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
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

// MARK: - KEYBOARD CONTROLLER

extension ForgotPasswordViewController {

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo          = notification.userInfo,
        let keyboardSize            = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]            as? NSValue)?.cgRectValue,
        let duration: TimeInterval  = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]   as? NSNumber)?.doubleValue else { return }
        
        bottomConstraint.constant += keyboardSize.height
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func keyboardDidHide(notification: Notification) {
        
        guard let userInfo          = notification.userInfo,
        let duration: TimeInterval  = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        bottomConstraint.constant = 20
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
