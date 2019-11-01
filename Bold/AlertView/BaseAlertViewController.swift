//
//  BaseAlertViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/10/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class BaseAlertViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    
    var typeAlert : BoldAlertType!
    
    private var activeOkButton: VoidCallback?
    private var activeCancelButton: VoidCallback?
    
    private var viewAlert : UIView!
    private var topConstrain: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overlayView.alpha = 0
 
        switch typeAlert {
        case .congratulationsAction1?, .congratulationsAction2?, .goalIsAchievedAchievedYourGoal?, .goalIsAchievedMadeImportantDecision?:
            viewAlert = CongratulationsAlertView.loadViewFromNib() as CongratulationsAlertView
            guard let viewAlert = viewAlert as? CongratulationsAlertView else {return}
            viewAlert.config(type: typeAlert)
            viewAlert.activeOkButton = { [unowned self] in
                self.activeOkButton?()
                self.hideAnimateView()
            }
        case .youveMissedYourAction?:
            viewAlert = MissedYouOneButtonAlertView.loadViewFromNib() as MissedYouOneButtonAlertView
            guard let viewAlert = viewAlert as? MissedYouOneButtonAlertView else {return}
            viewAlert.config(type: typeAlert)
            viewAlert.activeOkButton = { [unowned self] in
                self.activeOkButton?()
                self.hideAnimateView()
            }
        case .youveMissedYourActionLock?:
            viewAlert = MissedYouTwoButtonAlertView.loadViewFromNib() as MissedYouTwoButtonAlertView
            guard let viewAlert = viewAlert as? MissedYouTwoButtonAlertView else {return}
            viewAlert.config(type: typeAlert)
            viewAlert.activeOkButton = { [unowned self] in
                self.activeOkButton?()
                self.hideAnimateView()
            }
            viewAlert.activeCancelButton = { [unowned self] in
                self.hideAnimateView()
            }
        case .dontGiveUpMoveToLaterDate?, .dontGiveUpDeleteGoal?, .dontGiveUpDeleteAction?, .dontGiveUpDeleteStake?, .dontGiveUpDeleteThisTask?:
            viewAlert = DontGiveUpAlertView.loadViewFromNib() as DontGiveUpAlertView
            guard let viewAlert = viewAlert as? DontGiveUpAlertView else {return}
            viewAlert.config(type: typeAlert)
            viewAlert.activeOkButton = { [unowned self] in
                self.activeOkButton?()
                self.hideAnimateView()
            }
            viewAlert.activeCancelButton = { [unowned self] in
                self.hideAnimateView()
            }
        case .none:
            viewAlert = UIView()
        }
        
        viewAlert.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewAlert)
        
        topConstrain = viewAlert.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraint = viewAlert.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            viewAlert.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            viewAlert.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topConstrain
            ])
    }

    class func showAlert(type: BoldAlertType, tapOk: @escaping (() -> Void)) -> BaseAlertViewController {
        let alertVC = StoryboardScene.AlertView.baseAlertViewController.instantiate()
        alertVC.typeAlert = type
        alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alertVC.activeOkButton = tapOk
        return alertVC
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        viewAlert.roundCorners(corners: [.topLeft, .topRight], radius: 18)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAnimateView()
    }
    
    func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.topConstrain.isActive = false
            self.bottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0
            self.bottomConstraint.isActive = false
            self.topConstrain.isActive = true
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            //self.dismiss(animated: false, completion: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
}
