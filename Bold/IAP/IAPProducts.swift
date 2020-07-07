//
//  IAPProducts.swift
//  Bold
//
//  Created by Denis Grishchenko on 7/7/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

struct IAPProducts {
    
    static let MonthlySubscription = "com.nikonorov.newBold.MonthlySubscription"
    static let YearlySubscription = "com.nikonorov.newBold.YearlySubscription"
    
    static let subscriptionIds: Set<ProductIdentifier> = [IAPProducts.MonthlySubscription, IAPProducts.YearlySubscription]
    
    static let store = IAPHelper(productIds: IAPProducts.subscriptionIds)
    
}
