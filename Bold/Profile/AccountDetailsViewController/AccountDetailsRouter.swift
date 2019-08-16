//
//  AccountDetailsRouter.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum AccountDetailsRouterInput {
    case performSegue(segue: StoryboardSegue.Profile, sender: AccountDetailsItem)
    case pop
}

protocol AccountDetailsRouterInputProtocol: RouterProtocol {
    func input(_ inputCase: AccountDetailsRouterInput)
}

class AccountDetailsRouter: AccountDetailsRouterInputProtocol {
    typealias View = AccountDetailsViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: AccountDetailsRouterInput) {
        switch inputCase {
        case .performSegue(let info):
            viewController.perform(segue: info.segue, sender: info.sender)
        case .pop:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
}
