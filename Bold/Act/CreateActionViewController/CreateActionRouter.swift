//
//  CreateActionRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

enum CreateActionInputRouter {
    case presentSetting(AddActionCellType)
    case stake
    case share
    case cancel
    case systemShareAction(UIImage, String)
    case shareByEmail(UIImage, String, String)
}

protocol CreateActionInputRouterProtocol {
    func input(_ inputCase: CreateActionInputRouter)
}

class CreateActionRouter: RouterProtocol, CreateActionInputRouterProtocol {
    
    typealias View = CreateActionViewController
    
    weak var viewController: View!
 
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: CreateActionInputRouter) {
        switch inputCase {
        case .presentSetting(let type):
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.configurateActionIdentifier.rawValue, sender: type)
        case .stake:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.stakeIdentifier.rawValue, sender: nil)
        case .share:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.shareWithFriendsIdentifier.rawValue, sender: nil)
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        case .systemShareAction(let image, let title):
            configureShareActivity(with: image, and: title)
        case .shareByEmail(let image, let link, let title):
            configureShareEmail(with: image, and: link, title: title)
        }
    }
    
    func configureShareActivity(with image: UIImage, and title: String) {
        
        let titleItem = "\(title) \n\(GlobalConstants.appURL)"
        
        let items: [Any] = [titleItem, image]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        viewController.alertController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func configureShareEmail(with image: UIImage, and link: String, title: String) {
        
        if !MFMailComposeViewController.canSendMail() { return }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = viewController
        composeVC.setSubject(title)
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            composeVC.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "\(title).jpeg")
        }
        
        viewController.alertController?.present(composeVC, animated: true, completion: nil)
        
    }

}
