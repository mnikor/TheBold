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
    }
    
    private func playLogo() {
        guard let path = Bundle.main.url(forResource: "boldlogo.mp4".fileName(), withExtension: "boldlogo.mp4".fileExtension())
            else { return }
        videoView.configure(url: path)
        videoView.play()
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
                    let viewController = StoryboardScene.Splash.onboardViewControllerIdentifier.instantiate()
                    viewController.transitioningDelegate = self
                    self?.present(viewController, animated: true)
                }
            }
        }
    }
    
    func videoViewDidEndPlayingVideo() {
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
