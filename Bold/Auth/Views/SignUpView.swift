//
//  SignUpView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/7/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import ActiveLabel

enum TypeAuthView {
    case signUp
    case logIn
}

protocol SignUpViewDelegate: class {
    func tapForgot()
    func signUpViewDidTapSignUp(_ signUpView: SignUpView)
    func tapFacebook()
    func tapShowSignUp()
    func tapShowLogIn()
    func signUpViewDidTapAtPrivacyPolicy()
    func signUpViewDidTapAtTermsOfUse()
}

class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
    var name: String? {
        return yourNameTextField.text
    }
    
    var email: String? {
        return emailTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    var acceptTerms: Bool {
        return !checkImageView.isHidden
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yourNameTextField: UITextField!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var privacyPolicyLabel: ActiveLabel!
    @IBOutlet weak var makePasswordVisibleButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var logInButton: RoundedButton!
    @IBOutlet weak var betweenButtonLabel: UILabel!
    @IBOutlet weak var facebookButton: RoundedButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomButton: RoundedButton!
    @IBOutlet weak var verticalSpaceButtonConstraint: NSLayoutConstraint!
    
    var authType : TypeAuthView = .signUp
    
    @IBAction func tapForgot(_ sender: UIButton) {
        delegate?.tapForgot()
    }
    
    @IBAction func didTapMakePasswordVisible(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            makePasswordVisibleButton.setImage(UIImage(named: "passwordEye"), for: .normal)
        } else {
            makePasswordVisibleButton.setImage(UIImage(named: "passwordEye_on"), for: .normal)
        }
    }
    
    @IBAction func tapFirstButton(_ sender: Any) {
        delegate?.signUpViewDidTapSignUp(self)
    }
    
    @IBAction func tapFacebookButton(_ sender: Any) {
        delegate?.tapFacebook()
    }
    
    @IBAction func tapBottonButton(_ sender: Any) {
        switch authType {
        case .signUp:
            delegate?.tapShowLogIn()
        case .logIn:
            delegate?.tapShowSignUp()
        }
    }
    
    class func loadViewFromNib() -> SignUpView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! SignUpView
        return nibView
    }
    
    override func layoutSubviews() {
        roundCorners(corners: [.topLeft, .topRight], radius: 14.0)
    }
    
    func config(typeView: TypeAuthView) {
        authType = typeView
        self.translatesAutoresizingMaskIntoConstraints = false
        
        Localize(typeView: typeView)
    }
    
    private func Localize(typeView: TypeAuthView) {
        switch typeView {
        case .logIn:
            titleLabel?.text = L10n.Authorization.logIn
            forgotButton.setTitle(L10n.Authorization.iForgot, for: .normal)
            logInButton.setTitle(L10n.Authorization.logInButton, for: .normal)
            betweenButtonLabel.text = L10n.Authorization.orLoginWith
            bottomLabel.text = L10n.Authorization.haventAnAccount
            
//            verticalSpaceButtonConstraint.constant = 40
            forgotButton.isHidden = false
            emailTopConstraint.constant = 25
            yourNameTextField.isHidden = true
            checkBoxImageView.isHidden = true
            privacyPolicyLabel.isHidden = true
        case .signUp:
            titleLabel?.text = L10n.Authorization.signUp
            logInButton.setTitle(L10n.Authorization.signUpButton, for: .normal)
            betweenButtonLabel.text = L10n.Authorization.orSignUpWith
            bottomLabel.text = L10n.Authorization.haveAnAccount
            configurePrivacyPolicy()
//            privacyPolicyLabel.text = L10n.Authorization.termsAndPrivacy
            
//            verticalSpaceButtonConstraint.constant = 12
            forgotButton.isHidden = true
            emailTopConstraint.constant = 90
            yourNameTextField.isHidden = false
            checkBoxImageView.isHidden = false
            privacyPolicyLabel.isHidden = false
        }
        emailTextField.placeholder = L10n.Authorization.email
        passwordTextField.placeholder = L10n.Authorization.password
        facebookButton.setTitle(L10n.Authorization.facebook, for: .normal)
        checkImageView.isHidden = true
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func configurePrivacyPolicy() {
        let privacyPolicyType = ActiveType.custom(pattern: "\\s\(L10n.Authorization.privacyPolicy)\\b")
        let termsType = ActiveType.custom(pattern: "\\s\(L10n.Authorization.terms)\\s")
        privacyPolicyLabel.enabledTypes = [privacyPolicyType, termsType]
        privacyPolicyLabel.text = L10n.Authorization.termsAndPrivacy
        privacyPolicyLabel.customColor[privacyPolicyType] = UIColor(red: 80/255, green: 108/255, blue: 216/255, alpha: 1)
        privacyPolicyLabel.customColor[termsType] = UIColor(red: 80/255, green: 108/255, blue: 216/255, alpha: 1)
        privacyPolicyLabel.customSelectedColor[privacyPolicyType] = UIColor(red: 80/255, green: 108/255, blue: 216/255, alpha: 1)
        privacyPolicyLabel.customSelectedColor[termsType] = UIColor(red: 80/255, green: 108/255, blue: 216/255, alpha: 1)
        
        privacyPolicyLabel.handleCustomTap(for: privacyPolicyType) { [weak self] _ in
            self?.delegate?.signUpViewDidTapAtPrivacyPolicy()
        }
        
        privacyPolicyLabel.handleCustomTap(for: termsType) { [weak self] _ in
            self?.delegate?.signUpViewDidTapAtTermsOfUse()
        }
    }
    
    @IBAction func didTapAtCheckBox(_ sender: Any) {
        checkImageView.isHidden = !checkImageView.isHidden
    }
    
}
