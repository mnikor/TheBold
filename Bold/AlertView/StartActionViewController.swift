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
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    
    var activeStartButton : (() -> Void)?
    private var content: Content!
    
    @IBAction func tapStartButton(_ sender: UIButton) {
        activeStartButton?()
        hideAnimateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        overlayView.alpha = 0
        bottomContentViewConstraint.constant = -self.contentView.bounds.height
        addSwipe()
        configureContent(content)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    class func createController(content: Content, tapOk: @escaping (() -> Void)) -> StartActionViewController {
        let addVC = StoryboardScene.AlertView.startActionViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeStartButton = tapOk
        addVC.content = content
        return addVC
    }

    func presentedBy(_ vc: UIViewController) {
        vc.present(self, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    private func configureContent(_ content: Content) {
        if let smallImage = content.imageUrl {
            coverImageView.setImageAnimated(path: smallImage, placeholder: Asset.actionBackground.image)
        }
        timeButton.isUserInteractionEnabled = false
        timeButton.isHidden = content.durationRead == 0
        durationLabel.isHidden = content.durationRead == 0
        if  content.durationRead != 0 {
            durationLabel.text = "\(content.durationRead) min"
        }
        authorLabel.text = content.authorName
        titleTextView.text = content.title
    }
    
    private func addSwipe() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSwipe))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        overlayView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        swipe.direction = .down
        contentView.addGestureRecognizer(swipe)
    }
    
    @objc private func actionSwipe() {
        hideAnimateView()
    }

    private func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.bottomContentViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideAnimateView() {
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
