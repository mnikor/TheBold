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
        navigationController?.pushViewController(vc, animated: true)
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
        // add terms of use page
    }
    
    func tapForgot() {
        let forgotPasswordVC = StoryboardScene.Auth.forgotPasswordViewControllerIdentifier.instantiate()
        alertViewController?.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func signUpViewDidTapSignUp(_ signUpView: SignUpView) {
        switch signUpView {
        case loginView:
            login()
        case self.signUpView:
            signUp()
        default:
            break
        }
    }
    
    func tapFacebook() {
        print("Facebook")
    }
    
    func tapShowSignUp() {
        alertViewController = showAlert(with: signUpView, completion: nil)
    }
    
    func tapShowLogIn() {
        alertViewController = showAlert(with: loginView, completion: nil)
    }
    
    func signUpViewDidTapAtPrivacyPolicy() {
        // TODO: - show privacy policy
    }
    
    private func login() {
        let email = loginView.email
        // add email validation
        let password = loginView.password
        // add password validation
        NetworkService.shared.login(email: email ?? "",
                                    password: password ?? "") { [weak self] result in
                                        switch result {
                                        case .failure(let error):
                                            // add error handling
                                            break
                                        case .success(let profile):
                                            SessionManager.shared.profile = profile
                                            let vc = StoryboardScene.Menu.initialScene.instantiate()
                                            self?.alertViewController?.navigationController?.pushViewController(vc, animated: true)
                                        }
        }
    }
    
    private func signUp() {
        let name = signUpView.name
        let email = signUpView.email
        // add email validation
        let password = signUpView.password
        // add password validation
        let acceptTerms = signUpView.acceptTerms
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
                                            SessionManager.shared.profile = profile
                                            let vc = StoryboardScene.Menu.initialScene.instantiate()
                                            self?.alertViewController?.navigationController?.pushViewController(vc, animated: true)
                                        }
        }
    }
    
}
