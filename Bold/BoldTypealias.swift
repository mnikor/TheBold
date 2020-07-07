//
//  BoldTypealias.swift
//  Bold
//
//  Created by Alexander Kovalov on 31.10.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import StoreKit

typealias VoidCallback = () -> Void
typealias Callback<T> = (T) -> Void
typealias DualCallback<T, U> = (T, U) -> Void
typealias ReturningCallback<T> = () -> T

// IAP

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
