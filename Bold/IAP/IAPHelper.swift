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
    
    // MARK: - INIT
    
    init(productIds: Set<ProductIdentifier>) {
        self.productIdentifiers = productIds
        
        for id in productIds {
            let purchased = UserDefaults.standard.bool(forKey: id)
            if purchased {
                purchasedProductIds.insert(id)
            }
        }
        
        super.init()
        
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
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
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
    
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
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
        
        deliverPurchaseNotification(for: transaction.payment.productIdentifier)
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productId = transaction.original?.payment.productIdentifier else { return }
        
        deliverPurchaseNotification(for: productId)
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let error = transaction.error {
            print(error.localizedDescription)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotification(for identifier: String?) {
        guard let id = identifier else { return }
        
        purchasedProductIds.insert(id)
        UserDefaults.standard.set(true, forKey: id)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: id)
        
        premiumUser()
    }
    
    private func premiumUser() {
        let user = DataSource.shared.readUser()
        user.premiumOn = true
        
        DataSource.shared.saveBackgroundContext()
    }
    
}