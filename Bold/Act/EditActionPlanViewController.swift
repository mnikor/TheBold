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
    
    override class func createController(tapOk: @escaping (() -> Void)) -> EditActionPlanViewController {
        let addVC = StoryboardScene.Act.editActionPlanViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeOkButton = tapOk
        return addVC
    }
    
    class func createController(actionID: String?, eventID: String?, tapOk: @escaping (() -> Void), delete: @escaping (() -> Void)) -> EditActionPlanViewController {
        let addVC = createController(tapOk: tapOk)
        addVC.actionDeleteButton = delete
        addVC.actionID = actionID
        addVC.eventID = eventID
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
//        addActionVC.presenter.input(.deleteAction(success: { [weak self] in
//
//        }))
        actionDeleteButton?()
        hideAnimateView()
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
//        addActionVC.presenter.input(.updateAction(success: {
//            print("updateAction success")
//        }))
        
        guard let eventID = eventID else { return }
        
        DataSource.shared.doneEvent(eventID: eventID) { [weak self] in
            self?.activeOkButton?()
            self?.hideAnimateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.setTitle(L10n.done, for: .normal)
        deleteButton.setTitle(L10n.delete, for: .normal)
    }
    
}
