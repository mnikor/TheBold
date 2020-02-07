//
//  EditGoalViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 05.02.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

class EditGoalViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomAddActionConstraint: NSLayoutConstraint!
    
    var createGoalVC : CreateGoalViewController!
    var activeOkButton : (() -> Void)?
    var actionDeleteButton : (() -> Void)?
    
    var goalID : String?
    var points : Int!
    var isEditingGoal : Bool = false
    var navVC : UINavigationController!
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {

        if let actionIDTemp = goalID {
            deleteGoal(goalID: actionIDTemp)
        }
        actionDeleteButton?()
        hideAnimateView()
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        
        if isEditingGoal == false {
            if let goalIDTemp = goalID {
                tapDoneGoal(goalID: goalIDTemp)
            }
        }else {
            view.endEditing(true)
            createGoalVC.presenter.input(.updateGoal({
                print("Updated Goal")
            }))
        }
        
        activeOkButton?()
        hideAnimateView()
    }
    
    class func createController(goalID: String?, tapOk: @escaping VoidCallback) -> EditGoalViewController {
        
        let addVC = StoryboardScene.AlertView.editGoalViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeOkButton = tapOk
        addVC.goalID = goalID
        return addVC
    }
    
    func presentedBy(_ vc: UIViewController) {
        let navVC = UINavigationController(rootViewController: self)
        navVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.present(navVC, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayView.alpha = 0
        bottomAddActionConstraint.constant = -self.editView.bounds.height
        
        doneButton.setTitle(L10n.achieved, for: .normal)
        deleteButton.setTitle(L10n.delete, for: .normal)
        
        addSwipe()
        displayContentController()
    }
    
    func displayContentController() {
        self.createGoalVC = StoryboardScene.Act.createGoalViewController.instantiate()
        createGoalVC.presenter.baseConfigType = .editGoalSheet(goalID: goalID!)
        createGoalVC.presenter.tapEditCallback = { [weak self] in
            self?.isEditingGoal = true
            self?.doneButton.setTitle(L10n.save, for: .normal)
        }
        if let addActionVC = createGoalVC {
            // call before adding child view controller's view as subview
            addChild(addActionVC)
            
            addActionVC.view.frame = contentView.bounds
            contentView.addSubview(addActionVC.view)
            
            // call before adding child view controller's view as subview
            addActionVC.didMove(toParent: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    private func tapDoneGoal(goalID: String) {
        DataSource.shared.doneGoal(goalID: goalID) {
            print("Achieved Goal")
        }
    }
    
    private func deleteGoal(goalID: String) {
        
        AlertViewService.shared.input(.deleteGoal(points: PointsForAction.deleteGoal, tapYes: {
            LevelOfMasteryService.shared.input(.addPoints(points: PointsForAction.deleteGoal))
            DataSource.shared.deleteGoal(goalID: goalID) {
                print("--- Delete ---")
            }
        }))
    }
    
    private func addSwipe() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSwipe))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        overlayView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        swipe.direction = .down
        editView.addGestureRecognizer(swipe)
    }
    
    @objc private func actionSwipe() {
        hideAnimateView()
    }
    
    private func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.bottomAddActionConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0
            self.bottomAddActionConstraint.constant = -self.editView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.view.removeFromSuperview()
            self.navigationController?.removeFromParent()
        })
    }
    
}
