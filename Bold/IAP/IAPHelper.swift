//
//  IAPHelper.swift
//  Bold
//
//  Created by Denis Grishchenko on 7/7/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import StoreKit
import TPInAppReceipt

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
    
//    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
//        return purchasedProductIds.contains(productIdentifier)
//    }
    
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
    
    func validateAutoRenewableSubscription(_ productIdentifier: ProductIdentifier) -> Bool {
        if let receipt = try? InAppReceipt.localReceipt(){
            if receipt.hasActiveAutoRenewableSubscription(ofProductIdentifier: productIdentifier, forDate: Date()) {
                // user has subscription of the product, which is still active at the specified date
                 return true
            }
        }
        return false
    }
    
//    func validateReceipt(){
//
//
//        let urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
//        //                       let urlString = "https://buy.itunes.apple.com/verifyReceipt"
//
//        guard let receiptURL = Bundle.main.appStoreReceiptURL, let receiptString = try? Data(contentsOf: receiptURL).base64EncodedString() , let url = URL(string: urlString) else {
//            return
//        }
//
//        let requestData : [String : Any] = ["receipt-data" : receiptString,
//                                            "password" : "c4e66dd0639b45fb8540603e61c9531d",
//                                            "exclude-old-transactions" : false]
//        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = httpBody
//        URLSession.shared.dataTask(with: request)  { (data, response, error) in
//            // convert data to Dictionary and view purchases
//
////            let str = String(decoding: data!, as: UTF8.self)
////
////            let data = Data(str.utf8)
//
//            do {
//                // make sure this JSON is in the format we expect
//                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
//                    // try to read out a string array
////                    if let names = json["names"] as? [String] {
////                        print(names)
////                    }
//                    print("\(json)")
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//
//            print("\(data)")
////            print("\(json)")
//
//        }.resume()
//    }
    
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
                print("========productId====\(productId)")
                restoreUser()
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
        
        premiumUser()
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
        
        print("++++++PREMIUM ON")
        IAPHelper.isSubscribeUser()
    }
    
    private func restoreUser() {
        
        print("++++++RESTORE")
        isPremium = true
        checkSubscriptions()
        NotificationCenter.default.post(name: .IAPHelperPremiumNotification, object: nil)
    }
    
    func checkSubscriptions() {
        
        DispatchQueue.global(qos: .default).async {
            let isMonthlySubscriptionPaid = IAPProducts.shared.store.validateAutoRenewableSubscription(IAPProducts.MonthlySubscription)
            //isProductPurchased(IAPProducts.MonthlySubscription)
            let isYearlySubscriptionPaid = IAPProducts.shared.store.validateAutoRenewableSubscription(IAPProducts.YearlySubscription)
            //isProductPurchased(IAPProducts.YearlySubscription)

            print("\n++++++CHECK PREMIUM \nisMonthlySubscriptionPaid = \(isMonthlySubscriptionPaid) \nisYearlySubscriptionPaid = \(isYearlySubscriptionPaid)\n")
            
            if !isMonthlySubscriptionPaid {
                UserDefaults.standard.set(false, forKey: IAPProducts.MonthlySubscription)
            }

            if !isYearlySubscriptionPaid {
                UserDefaults.standard.set(false, forKey: IAPProducts.YearlySubscription)
            }

            if !isMonthlySubscriptionPaid && !isYearlySubscriptionPaid {
                IAPHelper.clearUserDefaultsSubscriptions()
            }else {
                IAPHelper.isSubscribeUser()
            }
        }
    }
    
    func checkSubscriptionWithInterval() {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.checkSubscriptions()
        }
    }
    
    class func isSubscribeUser() {
        let user = DataSource.shared.readUser()
        user.premiumOn = true
        DataSource.shared.saveBackgroundContext()
    }
    
    class func clearUserDefaultsSubscriptions() {
        UserDefaults.standard.set(false, forKey: IAPProducts.MonthlySubscription)
        UserDefaults.standard.set(false, forKey: IAPProducts.YearlySubscription)
        
        let user = DataSource.shared.readUser()
        user.premiumOn = false
        DataSource.shared.saveBackgroundContext()
    }
}
