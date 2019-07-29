//
//  BaseAlertViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/10/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum BoldAlertType {
    case congratulations1
    case congratulations2
    case goalIsAchievedMadeImportantDecision
    case goalIsAchievedAchievedYourGoal
    case youveMissedYourActionOneButton
    case youveMissedYourActionTwoButton
    case dontGiveUp1
    case dontGiveUp2
    case dontGiveUp3
    case dontGiveUp4
    case dontGiveUp5
    
    func icon() -> UIImage {
        switch self {
        case .congratulations1, .congratulations2, .goalIsAchievedAchievedYourGoal, .goalIsAchievedMadeImportantDecision:
            return Asset.clapIcon.image
        case .youveMissedYourActionTwoButton:
            return Asset.lockIcon.image
        case .youveMissedYourActionOneButton, .dontGiveUp1, .dontGiveUp2, .dontGiveUp3, .dontGiveUp4, .dontGiveUp5:
            return Asset.shapeOrangeIcon.image
        }
    }
    
    func titleText() -> String {
        switch self {
        case .congratulations1, .congratulations2:
            return L10n.Alert.congratulations
        case .goalIsAchievedAchievedYourGoal, .goalIsAchievedMadeImportantDecision:
            return L10n.Alert.goalIsAchieved
        case .youveMissedYourActionTwoButton, .youveMissedYourActionOneButton:
            return L10n.Alert.youveMissedYourAction
        case .dontGiveUp1, .dontGiveUp2, .dontGiveUp3, .dontGiveUp4, .dontGiveUp5:
            return L10n.Alert.dontGiveUp
        }
    }
    
    func text() -> String {
        switch self {
        case .congratulations1:
            return L10n.Alert.congratulationsText1
        case .congratulations2:
            return L10n.Alert.congratulationsText2
        case .goalIsAchievedAchievedYourGoal:
            return L10n.Alert.importantDecision
        case .goalIsAchievedMadeImportantDecision:
            return L10n.Alert.goalFantastic
        case .youveMissedYourActionOneButton:
            return L10n.Alert.dontGiveUpKeepGoing
        case .youveMissedYourActionTwoButton:
            return L10n.Alert.yourGoalIsLockedNow
        case .dontGiveUp1:
            return L10n.Alert.sometimesItsHardToFollowYourPlansLaterDate
        case .dontGiveUp2:
            return L10n.Alert.sometimesGoalsBecomeIrrelevant
        case .dontGiveUp3:
            return L10n.Alert.sometimesActionsBecomeIrrelevantAsWeAdaptOurStrategy
        case .dontGiveUp4:
            return L10n.Alert.areYouSureYouWantToDeleteThisStake
        case .dontGiveUp5:
            return L10n.Alert.sometimesItsHardToFollowYourPlansDeleteThisTask
        }
    }
}

class BaseAlertViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    
    var typeAlert : BoldAlertType!
    
    private var activeOkButton: (() -> Void)?
    private var activeCancelButton: (() -> Void)?
    
    private var viewAlert : UIView!
    private var topConstrain: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overlayView.alpha = 0
 
        switch typeAlert {
        case .congratulations1?, .congratulations2?, .goalIsAchievedAchievedYourGoal?, .goalIsAchievedMadeImportantDecision?:
            viewAlert = CongratulationsAlertView.loadViewFromNib() as CongratulationsAlertView
            guard let viewAlert = viewAlert as? CongratulationsAlertView else {return}
            viewAlert.config(type: typeAlert)
            viewAlert.activeOkButton = { [unowned self] in
                self.activeOkButton?()
                self.hideAnimateView()
            }
        case .youveMissedYourActionOneButton?:
            viewAlert = MissedYouOneButtonAlertView.loadViewFromNib() as MissedYouOneButtonAlertView
            guard let viewAlert = viewAlert as? MissedYouOneButtonAlertView else {return}
            viewAlert.config(type: typeAlert)
            viewAlert.activeOkButton = { [unowned self] in
                self.activeOkButton?()
                self.hideAnimateView()
            }
        case .youveMissedYourActionTwoButton?:
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
        case .dontGiveUp1?, .dontGiveUp2?, .dontGiveUp3?, .dontGiveUp4?, .dontGiveUp5?:
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
        let alertVC = StoryboardScene.Act.baseAlertViewController.instantiate()
        alertVC.typeAlert = type
        alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alertVC.activeOkButton = tapOk
        return alertVC
    }
    
    func present(_ vc: UIViewController) {
        vc.present(self, animated: false, completion: nil)
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
            self.dismiss(animated: false, completion: nil)
        })
    }
    
}
