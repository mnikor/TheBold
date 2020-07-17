//
//  AppDelegate.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/28/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hostController: HostViewController?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = getRootViewController()
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        
        LevelOfMasteryService.shared.input(.calculateProgress)
//        LevelOfMasteryService.shared.input(.checkAllGoalsAndAction)
        
        NotificationService.shared.delegate = self
        NotificationService.shared.input(.resetBadgeNumber)
        
        /// Download in-app products
        let _ = IAPProducts.shared
        
        return true
    }
    
    func clearCoreData() {
        deleteAllData("Action")
        deleteAllData("Content")
        deleteAllData("Goal")
        deleteAllData("User")
        deleteAllData("Event")
        deleteAllData("File")
        deleteAllData("DaysOfWeek")
        deleteAllData("Reminder")
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try DataSource.shared.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                DataSource.shared.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func showAuth() {
        
    }
    
    private func getRootViewController() -> UIViewController {
        
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
        return rootViewController
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}

