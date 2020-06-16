//
//  PremiumViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum PremiumType {
    case monthly
    case yearly
}

class PremiumViewController: UIViewController {
    
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var yearlyView: UIView!
    @IBOutlet weak var congratsView: UIView!
    
    private var premium : PremiumType!
    
    @IBAction func closeButton(_ sender: UIButton) {
        if let nc = navigationController {
            nc.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapMonthlyButton(_ sender: UIButton) {
        selectPremium(type: .monthly)
    }
    
    @IBAction func tapYearlyButton(_ sender: UIButton) {
        selectPremium(type: .yearly)
    }
    
    @IBAction func tapUnlockPremiumButton(_ sender: UIButton) {
        congratsView.isHidden = false
    }
    
    @IBAction func termsAndConditionAction() {
        let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        vc.viewModel = .termsOfUse
        present(vc, animated: true)
    }
    
    @IBAction func congratsDoneButton() {
        
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func selectPremium(type: PremiumType) {
        premium = type
        addShadow(to: type == .monthly ? monthlyView : yearlyView)
        removeShadow(from: type == .monthly ? yearlyView : monthlyView)
    }
    
    private func addShadow(to view: UIView) {
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor(red: 19/255, green: 28/255, blue: 50/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 0.14
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowPath = nil
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.masksToBounds = false
    }
    
    private func removeShadow(from view: UIView) {
        view.backgroundColor = UIColor(red: 243/255, green: 245/255, blue: 248/255, alpha: 1)
        view.layer.shadowColor = nil
        view.layer.shadowOpacity = 0.0
        view.layer.shadowOffset = .zero
    }
    
}
