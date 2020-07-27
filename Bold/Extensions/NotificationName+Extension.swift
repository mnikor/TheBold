//
//  NotificationName+Extension.swift
//  Bold
//
//  Created by Admin on 05.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let profileChanged = Notification.Name("profile changed")
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
    static let IAPHelperSubscriptionPurchaseNotification = Notification.Name("IAPHelperSubscriptionPurchaseNotification")
    static let IAPHelperPurchaseFailedNotification = Notification.Name("IAPHelperPurchaseFailedNotification")
}
