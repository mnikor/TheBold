//
//  AuthViewController.swift
//  Bold
//
//  Created by Denis Grishchenko on 6/23/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol AuthViewControllerInputProtocol: class {
    func showAlert(title: String, message: String)
    func setRootController(_ controller: UIViewController)
}

class AuthViewController: UIViewController, ViewProtocol, AuthViewControllerInputProtocol {
    
    // MARK: - VIEW PROTOCOL
    
    typealias Presenter = AuthViewPresenterInputProtocol
    typealias Configurator = AuthViewConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator!
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var signUpView: SignUpView!
    
    // MARK: - DELEGATE
    
    weak var delegate: SignUpViewDelegate?
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSwipeDownGesture()
        
        configurator = AuthViewConfigurator()
        configurator.configure(with: self)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - SETUP VIEW
    
    func setupView() {
        
        signUpView = SignUpView.loadViewFromNib()
        signUpView.delegate = self
        signUpView.config(typeView: .signUp)
        
        contentView.addSubview(signUpView)
        
        NSLayoutConstraint.activate([
        
            signUpView.topAnchor.constraint(equalTo: contentView.topAnchor),
            signUpView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            signUpView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
        
    }
    
    private func setupSwipeDownGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func hideKeyboard() {
        signUpView.emailTextField.resignFirstResponder()
        signUpView.yourNameTextField.resignFirstResponder()
        signUpView.passwordTextField.resignFirstResponder()
    }
    
}

// MARK: - SIGNUP VIEW DELEGATE

extension AuthViewController: SignUpViewDelegate {
    
    func tapForgot() {
        let forgotPasswordVC = StoryboardScene.Auth.forgotPasswordViewControllerIdentifier.instantiate()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func signUpViewDidTapSignUp(_ signUpView: SignUpView) {
        presenter.didTapSignUp(signUpView.authType,
                               email: signUpView.email,
                               password: signUpView.password,
                               name: signUpView.name,
                               acceptTerms: signUpView.acceptTerms)
    }
    
    func tapFacebook() {
        
    }
    
    func tapShowSignUp() {
        signUpView.config(typeView: .signUp)
    }
    
    func tapShowLogIn() {
        signUpView.config(typeView: .logIn)
    }
    
    func signUpViewDidTapAtPrivacyPolicy() {
        showTermsAndPrivacyView(descriptionView: .privacyPolicy)
    }
    
    func signUpViewDidTapAtTermsOfUse() {
        showTermsAndPrivacyView(descriptionView: .termsOfUse)
    }
    
    func showTermsAndPrivacyView(descriptionView: DescriptionViewModel) {
        let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        vc.viewModel = descriptionView
        let currentVC = UIApplication.topViewController ?? self
        currentVC.present(vc, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async { [weak self] in
            guard let ss = self else { return }
            ss.present(alert, animated: true, completion: nil)
        }
    }
    
    func setRootController(_ controller: UIViewController) {
        UIApplication.setRootView(controller, animated: true)
    }

}

// MARK: - KEYBOARD CONTROLLER

extension AuthViewController {

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo          = notification.userInfo,
        let keyboardSize            = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]            as? NSValue)?.cgRectValue,
        let duration: TimeInterval  = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]   as? NSNumber)?.doubleValue else { return }
        
        heightConstraint.constant += keyboardSize.height
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func keyboardDidHide(notification: Notification) {
        
        guard let userInfo          = notification.userInfo,
        let duration: TimeInterval  = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        heightConstraint.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}
