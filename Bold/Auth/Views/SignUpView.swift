//
//  SignUpView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/7/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum TypeAuthView {
    case signUp
    case logIn
}

protocol SignUpViewDelegate: class {
    func tapForgot()
    func tapSignUp()
    func tapLogIn()
    func tapFacebook()
    func tapShowSignUp()
    func tapShowLogIn()
}

class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
    
    @IBAction func tapFirstButton(_ sender: Any) {
        switch authType {
        case .signUp:
            delegate?.tapSignUp()
        case .logIn:
            delegate?.tapLogIn()
        }
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
    
    func config(typeView: TypeAuthView, superView : UIView) {

        authType = typeView
        self.translatesAutoresizingMaskIntoConstraints = false
        
        Localize(typeView: typeView)
        
//        NSLayoutConstraint.activate([
//            //authView.topAnchor.constraint(equalTo: self.topAnchor),
//            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
//            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
////            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
//            ])
        
    }
    
    private func Localize(typeView: TypeAuthView) {
        switch typeView {
        case .logIn:
            titleLabel?.text = L10n.Authorization.logIn
            forgotButton.setTitle(L10n.Authorization.iForgot, for: .normal)
            logInButton.setTitle(L10n.Authorization.logInButton, for: .normal)
            betweenButtonLabel.text = L10n.Authorization.orLoginWith
            bottomLabel.text = L10n.Authorization.haventAnAccount
            
            verticalSpaceButtonConstraint.constant = 40
            forgotButton.isHidden = false
        case .signUp:
            titleLabel?.text = L10n.Authorization.signUp
            logInButton.setTitle(L10n.Authorization.signUpButton, for: .normal)
            betweenButtonLabel.text = L10n.Authorization.orSignUpWith
            bottomLabel.text = L10n.Authorization.haveAnAccount
            
            verticalSpaceButtonConstraint.constant = 12
            forgotButton.isHidden = true
        }
        emailTextField.placeholder = L10n.Authorization.email
        passwordTextField.placeholder = L10n.Authorization.password
        facebookButton.setTitle(L10n.Authorization.facebook, for: .normal)
    }
}
