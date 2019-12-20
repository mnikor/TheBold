//
//  StartActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class StartActionViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    
    var activeStartButton : (() -> Void)?
    
    @IBAction func tapStartButton(_ sender: UIButton) {
        activeStartButton?()
        hideAnimateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
//        overlayView.alpha = 0
        bottomContentViewConstraint.constant = -self.contentView.bounds.height
        addSwipe()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        overlayView.alpha = 0
    }
    
     class func createController(tapOk: @escaping (() -> Void)) -> StartActionViewController {
        let addVC = StoryboardScene.AlertView.startActionViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeStartButton = tapOk
        return addVC
    }

    func presentedBy(_ vc: UIViewController) {
        vc.present(self, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    func addSwipe() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSwipe))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        overlayView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        swipe.direction = .down
        contentView.addGestureRecognizer(swipe)
    }
    
    @objc func actionSwipe() {
        hideAnimateView()
    }

    func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.bottomContentViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0
            self.bottomContentViewConstraint.constant = -self.contentView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            //self.dismiss(animated: false, completion: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}
