//
//  IAPHelper.swift
//  Bold
//
//  Created by Denis Grishchenko on 7/7/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import StoreKit

class IAPHelper: NSObject {
    
    // MARK: - DATA SOURCE
    
    private let productIdentifiers: Set<ProductIdentifier>
    
    private var purchasedProductIds: Set<ProductIdentifier> = []
    
    private var productsRequest: SKProductsRequest?
    
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    var isPremium = false
    
    private var showRestorePopup = false
    
    // MARK: - INIT
    
    init(productIds: Set<ProductIdentifier>) {
        self.productIdentifiers = productIds
        
        super.init()
        
        clearRequestAndHandler()
        
        SKPaymentQueue.default().add(self)
    }
    
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
        
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        
        if IAPHelper.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            deliverPurchaseFailedNotification(with: "You can't make payments with this account")
        }
        
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIds.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func restoreWithPopUp() {
        showRestorePopup = true
        restorePurchases()
    }
    
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        for product in products {
            if product.productIdentifier == IAPProducts.MonthlySubscription {
                
                let price           = Double(truncating: product.price).removeZerosFromEnd()
                let monthlyPrice    = "\(product.priceLocale.currencySymbol ?? "$") \(price)"
                
                IAPProducts.shared.monthlyPrice = monthlyPrice
                
            } else if product.productIdentifier == IAPProducts.YearlySubscription {
                
                let price           = Double(truncating: product.price)
                let priceInYear     = price.removeZerosFromEnd()
                let priceInMonth    = (price / 12).removeZerosFromEnd()
                
                let yearlyPrice         = "\(product.priceLocale.currencySymbol ?? "$") \(priceInYear)"
                let yearlyPriceInMonth  = "\(product.priceLocale.currencySymbol ?? "$") \(priceInMonth)/month"
                
                IAPProducts.shared.yearlyPrice          = yearlyPrice
                IAPProducts.shared.yearlyPriceInMonth   = yearlyPriceInMonth
            }
        }
        
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                failed(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            case .deferred:
                break
            case .purchasing:
                break
            default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        
        if let date = transaction.transactionDate {
            if let minutes = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute {
                if minutes > 5 {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    return
                }
            }
        }
        
        let prodId = transaction.payment.productIdentifier
        
        switch prodId {
            case IAPProducts.MonthlySubscription, IAPProducts.YearlySubscription:
                deliverSubscriptionsPurchaseNotification(for: prodId)
            default:
                deliverPurchaseNotification(for: prodId)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productId = transaction.original?.payment.productIdentifier else { return }
        
        if !isPremium {
            if productId == IAPProducts.MonthlySubscription || productId == IAPProducts.YearlySubscription {
                premiumUser()
                purchasedProductIds.insert(productId)
                UserDefaults.standard.set(true, forKey: productId)
                /// Show succesful alert if needed
                if showRestorePopup {
                    showRestorePopup = false
                    NotificationCenter.default.post(name: .SubscriptionRestoredSuccesfully, object: nil)
                }
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let error = transaction.error {
            deliverPurchaseFailedNotification(with: error.localizedDescription)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotification(for identifier: String?) {
        guard let id = identifier else { return }
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: id)
    }
    
    private func deliverSubscriptionsPurchaseNotification(for identifier: String?) {
        guard let id = identifier else { return }
        
        purchasedProductIds.insert(id)
        UserDefaults.standard.set(true, forKey: id)
        NotificationCenter.default.post(name: .IAPHelperSubscriptionPurchaseNotification, object: id)
    }
    
    private func deliverPurchaseFailedNotification(with message: String?) {
        var userInfo = ["errorDescription": "Unknown error"]
        
        if let error = message { userInfo["errorDescription"] = error }
        
        NotificationCenter.default.post(name: .IAPHelperPurchaseFailedNotification, object: nil, userInfo: userInfo)
    }
    
    private func premiumUser() {
        let user = DataSource.shared.readUser()
        user.premiumOn = true
        isPremium = true
        
        DataSource.shared.saveBackgroundContext()
        
        NotificationCenter.default.post(name: .IAPHelperPremiumNotification, object: nil)
    }
    
}
