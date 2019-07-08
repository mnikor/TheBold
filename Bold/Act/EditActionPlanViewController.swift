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
    
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        hideAnimateView()
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
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
