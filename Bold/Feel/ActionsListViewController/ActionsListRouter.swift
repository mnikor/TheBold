//
//  ActionsListRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum ActionsListInputRouter {
    case back
    case info(FeelTypeCell)
    case presentedBy(AddActionPlanViewController)
    case player(_ content: ActivityContent)
    case read(_ content: ActivityContent)
    case share(ActionEntity)
    case systemShare([Any])
}

protocol ActionsListRouterProtocol {
    func input(_ inputCase: ActionsListInputRouter)
}

class ActionsListRouter: RouterProtocol, ActionsListRouterProtocol {
    
    typealias View = ActionsListViewController
    
    weak var viewController: ActionsListViewController!
    
    var alertController: BlurAlertController?
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: ActionsListInputRouter) {
        switch inputCase {
        case .back:
            viewController.navigationController?.popViewController(animated: true)
        case .info(let type):
            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
            vc.viewModel = DescriptionViewModel.map(feelType: type)
//            vc.audioPlayerDelegate = viewController
            viewController.navigationController?.present(vc, animated: true, completion: nil)
        case .presentedBy(let vController):
            if let topVC = UIApplication.topViewController {
                vController.presentedBy(topVC)
            } else {
                vController.presentedBy(viewController)
            }
        case .player(content: let content):
            PlayerViewController.createController(content: content)
        case .read(content: let content):
            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
            vc.viewModel = DescriptionViewModel.map(activityContent: content)
            vc.isDownloadedContent = DataSource.shared.contains(content: content)
            viewController.navigationController?.present(vc, animated: true, completion: nil)
        case .share(let action):
            configureShareActivity(with: action)
        case .systemShare(let items):
            alertController?.shareContent(with: items)
        }
    }
    
    func configureShareActivity(with action: ActionEntity) {
        
        let shareView = RateAndShareView.loadFromNib()
        shareView.delegate = viewController
        shareView.configure(with: action)
        
        alertController = viewController.showAlert(with: shareView)
        
    }
}
