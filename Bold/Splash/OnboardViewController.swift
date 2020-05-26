//
//  OnboardViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/28/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SwiftVideoBackground

let kVideoName = "BackgroundVideo.MOV"

class OnboardViewController: UIViewController, AlertDisplayable {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: SCPageControlView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var findYourBoldnessButton: RoundedButton!
    
    private var signUpView: SignUpView = {
        let view = SignUpView.loadViewFromNib()
        view.authType = .signUp
        return view
    }()
    
    private var loginView: SignUpView = {
        let view = SignUpView.loadViewFromNib()
        view.authType = .logIn
        return view
    }()
    
    private var alertViewController: UIViewController?
    
    let player = VideoBackground()
    let texts = [OnboardTypeText.feel, OnboardTypeText.think, OnboardTypeText.act]
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        alertViewController = showAlert(with: signUpView, completion: nil)
    }
    
    @IBAction func tapFindYourBoldness(_ sender: UIButton) {
        let vc = StoryboardScene.Menu.initialScene.instantiate()
        UIApplication.setRootView(vc)
    }
    
//        override func viewDidDisappear(_ animated: Bool) {
//            super.viewDidDisappear(animated)
//            dismiss(animated: false, completion: nil)
//        }
    
    deinit {
        print("SplashViewController DEINIT")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.pageControl.set_view(texts.count, current: 0, current_color: .white)
        setupBackground()
    }
    
    private func configure() {
        pageControl.alpha = 0
        signUpButton.alpha = 0
        findYourBoldnessButton.alpha = 0
        collectionView.alpha = 0
        signUpView.delegate = self
        signUpView.config(typeView: signUpView.authType)
        loginView.delegate = self
        loginView.config(typeView: loginView.authType)
    }
    
    func animateContent() {
        let pageControlOriginY = pageControl.frame.origin.y
        let signUpButtonOriginY = signUpButton.frame.origin.y
        let collectionOriginY = collectionView.frame.origin.y
        let findYourBoldnessOriginY = findYourBoldnessButton.frame.origin.y
        pageControl.frame.origin.y += 10
        signUpButton.frame.origin.y += 10
        collectionView.frame.origin.y += 10
        findYourBoldnessButton.frame.origin.y += 10
        UIView.animate(withDuration: 0.9, animations: { [weak self] in
            self?.pageControl.frame.origin.y = pageControlOriginY
            self?.signUpButton.frame.origin.y = signUpButtonOriginY
            self?.collectionView.frame.origin.y = collectionOriginY
            self?.findYourBoldnessButton.frame.origin.y = findYourBoldnessOriginY
            self?.pageControl.alpha = 1
            self?.signUpButton.alpha = 1
            self?.collectionView.alpha = 1
            self?.findYourBoldnessButton.alpha = 1
        })
    }
    
    func setupBackground() {
        try? player.play(
            view: self.view,
            videoName: kVideoName.fileName(),
            videoType: kVideoName.fileExtension(),
            isMuted: true,
            darkness: 0,
            willLoopVideo: true,
            setAudioSessionAmbient: false
        )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
}


extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as OnboardCell
        cell.configure(typeText: texts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.scroll_did(scrollView)
    }
    
}

extension OnboardViewController: SignUpViewDelegate {
    func signUpViewDidTapAtTermsOfUse() {
        let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        vc.viewModel = .termsOfUse
        let currentVC = UIApplication.topViewController ?? self
        currentVC.present(vc, animated: true)
    }
    
    func tapForgot() {
        let forgotPasswordVC = StoryboardScene.Auth.forgotPasswordViewControllerIdentifier.instantiate()
        alertViewController?.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func signUpViewDidTapSignUp(_ signUpView: SignUpView) {
        
        switch signUpView {
            
        case loginView:
            if !checkEmail(signUpView.emailTextField.text,
                           password: signUpView.passwordTextField.text,
                           name: nil,
                           acceptTerms: nil,
                           isSignUp: false) { return }
            login()
            
        case self.signUpView:
            if !checkEmail(signUpView.emailTextField.text,
                           password: signUpView.passwordTextField.text,
                           name: signUpView.yourNameTextField.text,
                           acceptTerms: signUpView.acceptTerms,
                           isSignUp: true) { return }
            signUp()
            
        default:
            break
        }
    }
    
    func checkEmail(_ email: String?, password: String?, name: String?, acceptTerms: Bool?, isSignUp: Bool) -> Bool {
        
        if isSignUp {
            guard let name = name, !name.isEmpty else {
                showAlert(title: "Warning", message: "Please enter your name")
                return false
            }
            
            guard let acceptTerms = acceptTerms, acceptTerms else {
                showAlert(title: "Warning", message: "Please accept Terms and conditions")
                return false
            }
        }
        
        guard let email = email, !email.isEmpty else {
            showAlert(title: "Warning", message: "Please enter your email")
            return false
        }
        
        if !email.isValidEmail() {
            showAlert(title: "Warning", message: "Please enter correct email")
            return false
        }
        
        guard let pass = password, !pass.isEmpty else {
            showAlert(title: "Warning", message: "Please enter password")
            return false
        }
        
        return true
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.alertViewController?.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func tapFacebook() {
        print("Facebook")
    }
    
    func tapShowSignUp() {
        if let alertViewController = alertViewController {
        alertViewController.dismiss(animated: true) { [weak self] in
            self?.alertViewController = self?.showAlert(with: self?.signUpView ?? UIView(), completion: nil)
        }
        } else {
            alertViewController = showAlert(with: signUpView, completion: nil)
        }
    }
    
    func tapShowLogIn() {
        if let alertViewController = alertViewController {
        alertViewController.dismiss(animated: true) { [weak self] in
            self?.alertViewController = self?.showAlert(with: self?.loginView ?? UIView(), completion: nil)
        }
        } else {
            alertViewController = showAlert(with: loginView, completion: nil)
        }
    }
    
    func signUpViewDidTapAtPrivacyPolicy() {
        let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        vc.viewModel = .privacyPolicy
        let currentVC = UIApplication.topViewController ?? self
        currentVC.present(vc, animated: true)
    }
    
    private func validateData(in signUpView: SignUpView) -> Bool {
        let email = signUpView.email
        let password = signUpView.password
        return !((Validator.shared.validate(text: email ?? "", type: .email) == .invalid) || (Validator.shared.validate(text: password ?? "", type: .password) == .invalid))
    }
    
    private func login() {
        guard validateData(in: loginView) else { return }
        let email = loginView.email
        let password = loginView.password
        NetworkService.shared.login(email: email ?? "",
                                    password: password ?? "") { [weak self] result in
                                        switch result {
                                        case .failure(let error):
                                            // add error handling
                                            break
                                        case .success(let profile):
                                            SessionManager.shared.profile = profile
                                            let vc = StoryboardScene.Menu.initialScene.instantiate()
                                            UIApplication.setRootView(vc,
                                                                      animated: true)
//                                            self?.alertViewController?.navigationController?.pushViewController(vc, animated: true)
                                        }
        }
    }
    
    private func signUp() {
        let acceptTerms = signUpView.acceptTerms
        guard acceptTerms,
            validateData(in: signUpView)
            else { return }
        let name = signUpView.name
        let email = signUpView.email
        let password = signUpView.password
        NetworkService.shared.signUp(firstName: name,
                                     lastName: nil,
                                     email: email ?? "",
                                     password: password ?? "",
                                     acceptTerms: acceptTerms) { [weak self] result in
                                        switch result {
                                        case .failure(let error):
                                            // add error handling
                                            break
                                        case .success(let profile):
                                            SettingsService.shared.firstEntrance = true
                                            SessionManager.shared.profile = profile
                                            let vc = StoryboardScene.Menu.initialScene.instantiate()
                                            UIApplication.setRootView(vc,
                                            animated: true)
//                                            self?.alertViewController?.navigationController?.pushViewController(vc, animated: true)
                                        }
        }
    }
    
}
