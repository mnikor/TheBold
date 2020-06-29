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
    case listenPreview(_ content: ActivityContent)
    case player(_ content: ActivityContent)
    case read(_ content: ActivityContent)
    case readPreview(_ content: ActivityContent)
    case share(ActionEntity)
    case systemShare([Any])
    case showPremium
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
            showPlayer(content: content)
        case .listenPreview(let content):
            PlayerViewController.createController(content: content)
        case .read(content: let content):
            showReadable(content: content)
        case .readPreview(let content):
            showReadableContent(content)
        case .share(let action):
            configureShareActivity(with: action)
        case .systemShare(let items):
            alertController?.shareContent(with: items)
        case .showPremium:
            showPremiumController()
        }
    }
    
    func configureShareActivity(with action: ActionEntity) {
        let shareView = RateAndShareView.loadFromNib()
        shareView.delegate = viewController
        shareView.configure(with: action)
        
        alertController = viewController.showAlert(with: shareView)
    }
    
     private func isContentStatusLocked(content: ActivityContent) -> Bool {
           if content.contentStatus == .locked || content.contentStatus == .lockedPoints {
               return true
           } else {
               return false
           }
       }
    
    private func showPlayer(content: ActivityContent) {
        if isContentStatusLocked(content: content) {
            showPremiumController()
        } else {
            PlayerViewController.createController(content: content)
        }
    }
    
    private func showReadable(content: ActivityContent) {
        if isContentStatusLocked(content: content) {
            showPremiumController()
        } else {
            showReadableContent(content)
        }
    }
    
    func showReadableContent(_ content: ActivityContent) {
        let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        vc.viewModel = DescriptionViewModel.map(activityContent: content)
        vc.isDownloadedContent = DataSource.shared.contains(content: content)
        viewController.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func showPremiumController() {
        let vc = StoryboardScene.Settings.premiumViewController.instantiate()
        viewController.present(vc, animated: true, completion: nil)
    }
}
