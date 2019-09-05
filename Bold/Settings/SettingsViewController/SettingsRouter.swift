//
//  SettingsRouter.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum SettingsInputRouter {
    case showMenu
    case present(SettingsCellType)
}

protocol SettingsInputRouterProtocol: RouterProtocol {
    func input(_ inputCase: SettingsInputRouter)
}

class SettingsRouter: SettingsInputRouterProtocol {
    
    
    //MARK: RouterProtocol
    
    typealias View = SettingsViewController
    
    weak var viewController: View!
    
    
    //MARK: init
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    
    //MARK: SettingsInputRouterProtocol
    
    func input(_ inputCase: SettingsInputRouter) {
        switch inputCase {
        case .present(let cellType):
            //var viewController: UIViewController!
            //let storyboard: UIStoryboard = StoryboardScene.Settings.storyboard
            if cellType == .premium {
                viewController.perform(segue: StoryboardSegue.Settings.premium)
                //viewController = storyboard.instantiateViewController(withIdentifier: StoryboardSegue.Settings.premium.rawValue)
            } else if cellType == .terms || cellType == .privacy {
                viewController.perform(segue: StoryboardSegue.Settings.termsPrivacy)
                //viewController = storyboard.instantiateViewController(withIdentifier: StoryboardSegue.Settings.termsPrivacy.rawValue)
            }
            //viewController.present(viewController, animated: true, completion: nil)
        case .showMenu:
            viewController.showSideMenu()
        }
    }
}
