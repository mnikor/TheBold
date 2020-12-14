//
//  AnalyticService.swift
//  Bold
//
//  Created by Alexander Kovalov on 04.12.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
import AppsFlyerLib

class AnalyticService: NSObject {
    
    private var window : UIWindow? = nil// = UIApplication.shared.keyWindow
    
    func firstInit(window: UIWindow?) {
        
        self.window = window
        
        AppsFlyerLib.shared().appsFlyerDevKey = "CZoL8PMjbZz9jzdXAugYpJ"
        AppsFlyerLib.shared().appleAppID = "1491187912"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = false
    }
    
    // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
    func applicationDidBecomeActive() {
        AppsFlyerLib.shared().start()
    }
    
    // Open Univerasal Links
    // For Swift version < 4.2 replace function signature with the commented out code:
    func handlePushNotification(_ userInfo: [AnyHashable : Any]) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    // Reports app open from deep link for iOS 10 or later
    func openDeepLink(_ userActivity: NSUserActivity) {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    }
    
    // Open URI-scheme for iOS 9 and above
    func openURISheme(_ url: URL, sourceApplication: String?, annotation: Any) {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    // Report Push Notification attribution data for re-engagements
    func openPushNotification(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        AppsFlyerLib.shared().handleOpen(url, options: options)
    }
    
    func processAttributionData(_ params: [AnyHashable : Any]) {
        
        guard let campaign =  params["campaign"] as? String else { return }
        
        var homeNC : UINavigationController? = nil
        
        if let hostVC = self.window?.rootViewController as? HostViewController {
            
            let feelNC = hostVC.contentViewControllers.filter { (controller) -> Bool in
                if let nc = controller as? UINavigationController {
                    nc.popToRootViewController(animated: false)
                    return nc.viewControllers.first is HomeViewController
                }
                return false
            }
            
            guard let feelVC = feelNC.first as? UINavigationController else { return }
            homeNC = feelVC
            
            hostVC.selectContentViewController(feelVC)
//            hostVC.showStartController()
            
        }else {
            
            let hostVC = getRootViewController(isShowSplash: false) as? HostViewController
            self.window?.rootViewController = hostVC
            homeNC = hostVC?.contentViewControllers.first as? UINavigationController
        }
        
        switch campaign.lowercased() {
        case "home":
            break
        case "premium":
            showPremiumController(controller: homeNC!)
        case "meditation", "peptalks", "hypnosis", "lessons", "stories", "thoughts":
            showContent(content: campaign.lowercased(), controller: homeNC!)
        default:
            break
        }
        
    }
    
    func showPremiumController(controller: UINavigationController) {
        let vc = StoryboardScene.Settings.premiumViewController.instantiate()
        controller.present(vc, animated: true, completion: nil)
    }
    
    func showContent(content: String, controller: UINavigationController) {
        
        var type : FeelTypeCell!
        
        switch content {
        case "meditation":  type = .meditation
        case "peptalks":    type = .pepTalk
        case "hypnosis":    type = .hypnosis
        case "lessons":     type = .lessons
        case "stories":     type = .stories
        case "thoughts":    type = .citate
        default:
            break
        }
        
        if FeelTypeCell.citate == type {
            let citationVC = StoryboardScene.Think.citationBaseViewController.instantiate()
            controller.pushViewController(citationVC, animated: true)
        } else {
            let contentVC = StoryboardScene.Feel.actionsListViewController.instantiate() //as! ActionsListViewController
            contentVC.typeVC = type
            controller.pushViewController(contentVC, animated: true)
        }
    }
    
    func getRootViewController(isShowSplash: Bool = true) -> UIViewController {
        
        let rootViewController: UIViewController
        if let _ = SessionManager.shared.token {
            
            if arc4random_uniform(UInt32(100)) % 2 == 0 {
                rootViewController = StoryboardScene.Menu.storyboard.instantiateInitialViewController() ?? UIViewController()
            }else {
                rootViewController = StoryboardScene.Splash.storyboard.instantiateInitialViewController() ?? UIViewController()
            }
            
            NetworkService.shared.profile { result in
                switch result {
                case .failure(_):
                    // TODO: error handling
                    break
                case .success(let profile):
                    SessionManager.shared.profile = profile
                }
            }
        } else {
            rootViewController = StoryboardScene.Splash.storyboard.instantiateInitialViewController() ?? UIViewController()
        }
        
        if isShowSplash == false {
            return StoryboardScene.Menu.storyboard.instantiateInitialViewController() ?? UIViewController()
        }
        
        return rootViewController
    }

}

extension AnalyticService : AppsFlyerLibDelegate {
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("onAppOpenAttribution \(attributionData)")
        
        processAttributionData(attributionData)
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("onConversionDataSuccess \(conversionInfo)")
    }
    
    func onConversionDataFail(_ error: Error) {
        print("onConversionDataFail \(error)")
    }
    
}
