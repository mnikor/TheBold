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
    
    var transitedFromMenu = false
    
    private var alertViewController: UIViewController?
    
    let player = VideoBackground()
    let texts = [OnboardTypeText.feel, OnboardTypeText.think, OnboardTypeText.act]
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        showSignUpController()
    }
    
    @IBAction func tapFindYourBoldness(_ sender: UIButton) {
        let vc = StoryboardScene.Menu.initialScene.instantiate()
        UIApplication.setRootView(vc)
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if transitedFromMenu { tapSignUp(UIButton()) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    func showSignUpController() {
        
        let authVC = StoryboardScene.Auth.authViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: authVC)
        
        navigationController.modalPresentationStyle = UIModalPresentationStyle.custom
        navigationController.transitioningDelegate = self
        
                
        self.present(navigationController, animated: true, completion: nil)
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

extension OnboardViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return SignUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

class SignUpPresentationController : UIPresentationController {
    
    var signUpViewHeight: CGFloat = 620
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }

            return CGRect(x: 0, y: theView.bounds.height - signUpViewHeight, width: theView.bounds.width, height: signUpViewHeight)
        }
    }
}
