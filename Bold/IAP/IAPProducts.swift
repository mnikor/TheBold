//
//  IAPProducts.swift
//  Bold
//
//  Created by Denis Grishchenko on 7/7/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import StoreKit

class IAPProducts {
    
    static let shared = IAPProducts()
    
    // MARK: - SUBSCRIPTIONS
    
    static let MonthlySubscription = "com.nikonorov.newBold.MonthlySubscription"
    static let YearlySubscription = "com.nikonorov.newBold.YearlySubscription"
    
    // MARK: - DATA SOURCE
    
    var productsId: Set<ProductIdentifier> = [IAPProducts.MonthlySubscription, IAPProducts.YearlySubscription]
    
    var products = [SKProduct]()
    
    var store: IAPHelper!
    
    // MARK: - INIT
    
    init() {
        
        var tempArray = [Int]()
        
        for i in 1...50 {
            tempArray.append(i)
        }
        
        for i in stride(from: 55, to: 101, by: 5) {
            tempArray.append(i)
        }
        
        /// Append products Ids with stakes
        for val in tempArray {
            let stakeId = "com.nikonorov.newBold.Stake\(val)"
            productsId.insert(stakeId)
        }
        
        /// Init store
        store = IAPHelper(productIds: productsId)
        
        /// Load products from AppStore
        requestProducts()

    }
    
    // MARK: - REQUEST PRODUCTS
    
    private func requestProducts() {
        store.requestProducts {[weak self] (success, products) in
            guard let ss = self else { return }
            
            if success {
                if let products = products {
                    ss.products = products
                }
            } else {
                print("Can't request products from the app store")
            }
        }
    }
    
}
