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
    
    override class func createController(tapOk: @escaping (() -> Void)) -> EditActionPlanViewController {
        let addVC = StoryboardScene.Act.editActionPlanViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeOkButton = tapOk
        return addVC
    }
    
    class func createController(tapOk: @escaping (() -> Void), delete: @escaping (() -> Void)) -> EditActionPlanViewController {
        let addVC = createController(tapOk: tapOk)
        addVC.actionDeleteButton = delete
        return addVC
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        actionDeleteButton?()
        hideAnimateView()
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        activeOkButton?()
        hideAnimateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.setTitle(L10n.done, for: .normal)
        deleteButton.setTitle(L10n.delete, for: .normal)
    }
    

    override func addHeader() {
        listSettings.insert(AddActionEntity(type: .headerEditAction, currentValue: nil), at: 0)
    }

}
