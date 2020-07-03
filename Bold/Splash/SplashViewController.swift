//
//  SplashViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/28/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet private weak var videoView: VideoView!
    @IBOutlet private weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playLogo()
    }
    
    private func configure() {
        transitioningDelegate = self
        videoView.delegate = self
        label.alpha = 0
        /// To show some particular text at first app load we have to save state in UserDefaults
        randomText()
    }
    
    private func playLogo() {
        guard let path = Bundle.main.url(forResource: "boldlogo.mp4".fileName(), withExtension: "boldlogo.mp4".fileExtension())
            else { return }
        videoView.configure(url: path)
        videoView.play()
    }

    private func randomText() {
        
        let texts = [L10n.Splash.text0,L10n.Splash.text1, L10n.Splash.text2, L10n.Splash.text3, L10n.Splash.text4, L10n.Splash.text5, L10n.Splash.text6, L10n.Splash.text7, L10n.Splash.text8, L10n.Splash.text9, L10n.Splash.text10, L10n.Splash.text11]

        
        if let firstLoad = UserDefaults.standard.value(forKey: Constants.isFirstLoad) as? Bool {
            if !firstLoad {
                label.text = texts[Int(arc4random_uniform(UInt32(texts.count)))]
                return
            }
        }
        
        UserDefaults.standard.set(false, forKey: Constants.isFirstLoad)
        
        label.text = texts.first
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        dismiss(animated: false, completion: nil)
//    }
    
    deinit {
        print("SplashViewController DEINIT")
    }
}

extension SplashViewController: VideoViewDelegate {
    private func animateLabelAppearing(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        let labelOriginX = label.frame.origin.x
        label.frame.origin.x += 20
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
                        self?.label.alpha = 1
                        self?.label.frame.origin.x = labelOriginX
            }, completion: completion)
    }
    
    private func animateLabelsDisapearing(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
                        self?.label.alpha = 0
            }, completion: completion)
    }
    
    func videoViewStartPlaying() {
        let duration = (videoView.duration - 0.75) / 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            self?.animateLabelAppearing(duration: duration) { [weak self] _ in
                self?.animateLabelsDisapearing(duration: duration)
                DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.15) { [weak self] in
                    //let viewController = StoryboardScene.Splash.onboardViewControllerIdentifier.instantiate()
                    guard let viewController = self?.getRootViewController() else {return}
                    viewController.transitioningDelegate = self
                    self?.present(viewController, animated: true)
                }
            }
        }
    }
    
    func videoViewDidEndPlayingVideo() {
    }
    
    private func getRootViewController() -> UIViewController? {
        let rootViewController: UIViewController
        if let _ = SessionManager.shared.token {
            rootViewController = StoryboardScene.Menu.storyboard.instantiateInitialViewController() ?? UIViewController()
            UIApplication.setRootView(rootViewController, options: .transitionCrossDissolve)
            return nil
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = rootViewController
        } else {
            rootViewController = StoryboardScene.Splash.onboardViewControllerIdentifier.instantiate() 
        }
        return rootViewController
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension SplashViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}

// MARK: - Constants

private struct Constants {
    static let isFirstLoad = "FirstLoad"
}
