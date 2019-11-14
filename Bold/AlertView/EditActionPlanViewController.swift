//
//  EditActionPlanViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class EditActionPlanViewController: AddActionPlanViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var actionDeleteButton : (() -> Void)?
    var actionID : String?
    var eventID : String?
    var points : Int!
    
    override class func createController(tapOk: @escaping (() -> Void)) -> EditActionPlanViewController {
        let addVC = StoryboardScene.AlertView.editActionPlanViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeOkButton = tapOk
        return addVC
    }
    
    class func createController(actionID: String?, eventID: String?, points: Int, tapOk: @escaping (() -> Void), tapDelete: @escaping (() -> Void)) -> EditActionPlanViewController {
        let addVC = createController(tapOk: tapOk)
        addVC.actionDeleteButton = tapDelete
        addVC.actionID = actionID
        addVC.eventID = eventID
        addVC.points = points
        return addVC
    }
    
    override func displayContentController() {
            self.addActionVC = StoryboardScene.Act.createActionViewController.instantiate()
            addActionVC.presenter.baseConfigType = .editActionSheet(actionID: actionID)
        
            if let addActionVC = addActionVC {
                // call before adding child view controller's view as subview
                addChild(addActionVC)

                addActionVC.view.frame = contentView.bounds
                contentView.addSubview(addActionVC.view)

                // call before adding child view controller's view as subview
                addActionVC.didMove(toParent: self)
            }
        }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {

        if let actionIDTemp = actionID {
            deleteAction(actionID: actionIDTemp)
        }
        
        actionDeleteButton?()
        hideAnimateView()
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        
        if let eventIDTemp = eventID {
            tapDoneEvent(eventID: eventIDTemp)
        }
        
        activeOkButton?()
        hideAnimateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.setTitle(L10n.done, for: .normal)
        deleteButton.setTitle(L10n.delete, for: .normal)
    }
    
    private func tapDoneEvent(eventID: String) {
        DataSource.shared.doneEvent(eventID: eventID) {
            print("Done Event")
        }
    }
    
    private func deleteAction(actionID: String) {
        
        AlertViewService.shared.input(.deleteAction(points: points, tapYes: {
            
            LevelOfMasteryService.shared.input(.addPoints(points: PointsForAction.deleteAction))
            DataSource.shared.deleteAction(actionID: actionID) {
                print("--- Delete ---")
            }
        }))
    }
}
