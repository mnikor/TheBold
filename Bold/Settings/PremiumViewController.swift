//
//  PremiumViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import StoreKit

enum PremiumType {
    case monthly
    case yearly
}

class PremiumViewController: UIViewController {
    
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var yearlyView: UIView!
    @IBOutlet weak var yearlyPriceLabel: UILabel!
    @IBOutlet weak var congratsView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    
    private var premium : PremiumType!
    
    private var monthlyProduct: SKProduct?
    private var yearlyProduct: SKProduct?
    
    var fromThoughts = false
    
    @IBAction func closeButton(_ sender: UIButton) {
        if let nc = navigationController {
            nc.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapMonthlyButton(_ sender: UIButton) {
        guard let product = monthlyProduct else { return }
        premium = .monthly
        IAPProducts.store.buyProduct(product)
    }
    
    @IBAction func tapYearlyButton(_ sender: UIButton) {
        guard let product = monthlyProduct else { return }
        premium = .yearly
        IAPProducts.store.buyProduct(product)
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
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromThoughts {
            crossButton.isHidden = true
        }
        
        /// Load IAP subscriptions
        IAPProducts.store.requestProducts {[weak self] (success, products) in
            guard let ss = self else { return }
            
            if success {
                if let products = products {
                    for product in products {
                        if product.productIdentifier == IAPProducts.MonthlySubscription {
                            ss.monthlyProduct = product
                            if let isMonthly = UserDefaults.standard.value(forKey: product.productIdentifier) as? Bool {
                                if isMonthly { ss.premium = .monthly }
                            }
                        } else if product.productIdentifier == IAPProducts.YearlySubscription {
                            ss.yearlyProduct = product
                            if let isYearly = UserDefaults.standard.value(forKey: product.productIdentifier) as? Bool {
                                if isYearly { ss.premium = .yearly }
                            }
                        }
                        ss.selectPremium()
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - SETUP OBSERVER
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectPremium), name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    // MARK: - SETUP VIEW
    
    @objc private func selectPremium() {
        
        DispatchQueue.main.async { [weak self] in
            guard let ss = self else { return }
            
            switch ss.premium {
            case .monthly:
                ss.yearlyView.isUserInteractionEnabled = false
                ss.addShadow(to: ss.monthlyView)
            case .yearly:
                ss.monthlyView.isUserInteractionEnabled = false
                ss.removeShadow(from: ss.yearlyView)
            default:
                break
            }
        }
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
