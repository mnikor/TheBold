//
//  CongratsForPaymentViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 02.11.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

class CongratsForPaymentViewController: UIViewController {

    var doneCallBack: VoidCallback?
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - ACTION
    
    @IBAction private func gotItButtonAction() {
        doneCallBack?()
//        if let navController = navigationController {
//            navController.popViewController(animated: true)
//        } else {
//            dismiss(animated: true, completion: nil)
//        }
    }

}
