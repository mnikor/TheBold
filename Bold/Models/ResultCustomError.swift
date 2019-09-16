//
//  ResultCustomError.swift
//  Bold
//
//  Created by Admin on 9/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ResultCustomError <S, F> {
    case success(S)
    case failure(F?)
}
