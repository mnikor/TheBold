//
//  LevelOfMasteryRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum LevelOfMasteryRouterInput {
    case close
}

protocol LevelOfMasteryProtocol: RouterProtocol {
    func input(_ inputCase: LevelOfMasteryRouterInput)
}

class LevelOfMasteryRouter: LevelOfMasteryProtocol {
    
    typealias View = LevelOfMasteryViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: LevelOfMasteryRouterInput) {
        switch inputCase {
        case .close:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}