//
//  ThanksForPaymentViewController.swift
//  Bold
//
//  Created by Denis Grishchenko on 7/13/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

class ThanksForPaymentViewController: UIViewController {
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - ACTION
    
    @IBAction private func gotItButtonAction() {
        if let nc = navigationController {
            nc.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
