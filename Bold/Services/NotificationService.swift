//
//  NotificationService.swift
//  Bold
//
//  Created by Admin on 9/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}

enum StandardNotification {
    case createRemider(actionTitle: String, stake: Int, date: Date, reminderType: RemindMeType, identifier: String)
    case removeReimder(identifiers: [String])
    case removeAllReminder
    case resetBadgeNumber
}

private enum CategoryIdentifier: String {
    case stake
}

enum ActionIdentifier: String {
    case reminder
    
    var title: String {
        switch self {
        case .reminder:
            return "Remind me now"
        }
    }
}

typealias ActionCompletion = (actionIdentifier: ActionIdentifier, completion: () -> Void)

class NotificationService: NSObject {
    static let shared = NotificationService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    weak var delegate: UNUserNotificationCenterDelegate?
    
    private var actionCompletions: [String: [ActionCompletion]] = [:]
    private let stakeActionIdentifiers: [ActionIdentifier] = [.reminder]
    
    private let remindEventCompletion: () -> Void = {
        print("remind event")
        
    }
    
    private let openStakeCompletion: () -> Void = {
        print("open event")
        
        if let _ = UIApplication.shared.keyWindow?.rootViewController as? HostViewController,
            let actVC = StoryboardScene.Act.storyboard.instantiateInitialViewController() {
            HostViewController.showController(newVC: actVC)
        }
    }
    
    //MARK:- Init
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        configureCategories()
    }
    
    func input(_ notification: StandardNotification) {
        switch notification {
        case .createRemider(actionTitle: let title, stake: let stake, date: let date, reminderType: let reminderType, identifier: let identifier):
            createReminder(title: title, stake: stake, date: date, reminderType: reminderType, identifier: identifier)
        case .removeReimder(let identifiers):
            removeNotificationRequest(with: identifiers)
        case .removeAllReminder:
            print("removeAllReminder")
        case .resetBadgeNumber:
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func getLocalNotificationStatus(_ completion: @escaping (NotificationAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            let status: NotificationAuthorizationStatus
            switch settings.authorizationStatus {
            case .authorized:
                status = .authorized
            case .notDetermined:
                status = .notDetermined
            case .denied,
                 .provisional:
                status = .denied
            }
            completion(status)
        }
    }
    
    //MARK:- Create
    
    func createReminder(title: String, stake: Int, date: Date, reminderType: RemindMeType, identifier: String?) {
        getLocalNotificationStatus { [weak self] status in
            guard let self = self,
                status == .authorized
                else { return }
            
            var body : String!
            
            switch reminderType {
            case .beforeTheDay:
                body = L10n.Reminder.oneDayBeforeDueDate(title)
            case .onTheDay:
                body = L10n.Reminder.onTheDueDate(title)
            case .noReminders:
                break
            }
            
            if stake != 0 {
                let stakeStr = String(format: "%.2f$", Float(stake))
                body += L10n.Reminder.onTheDueDateAndStake(stakeStr)
            }
            
            let content = self.configureLocalNotificationContent(title: title, body: body)
            let trigger = self.createReminderTrigger(triggerDate: date)
            content.categoryIdentifier = CategoryIdentifier.stake.rawValue
            
            self.addRequest(with: identifier ?? UUID().uuidString, content: content, trigger: trigger)
        }
    }
    
    //    private func createYesNoNotification(message: String, completion: @escaping (Bool) -> Void) {
    //        getLocalNotificationStatus { [weak self] status in
    //            guard let self = self,
    //                status == .authorized
    //                else { return }
    //            let content = self.configureLocalNotificationContent(title: "", body: message)
    //            let trigger = self.createReminderTrigger(date: Date(timeIntervalSinceNow: 2), reminderType: .none)
    //            content.categoryIdentifier = CategoryIdentifier.yesNo.rawValue
    //            let requestIdentifier = UUID().uuidString
    //            self.actionCompletions[requestIdentifier] = self.yesNoActionIdentifiers.compactMap { action in
    //                let actionCompletion: () -> Void = { completion( action != .no) }
    //                return (action, actionCompletion)
    //            }
    //            self.addRequest(with: requestIdentifier, content: content, trigger: trigger)
    //        }
    //    }
    
    //    private func createRatingNotification(message: String ) {
    //        getLocalNotificationStatus { [weak self] status in
    //            guard let self = self,
    //                status == .authorized
    //                else { return }
    //            let content = self.configureLocalNotificationContent(title: "", body: message)
    //            let trigger = self.createReminderTrigger(date: Date(timeIntervalSinceNow: 2), reminderType: .none)
    //            content.categoryIdentifier = CategoryIdentifier.rating.rawValue
    //            let requestIdentifier = UUID().uuidString
    //            self.actionCompletions[requestIdentifier] = self.ratingActionIdentifiers.compactMap { action in
    //                switch action {
    //                case .reminder:
    //                    return (action, {
    //                        let newTrigger = self.createReminderTrigger(date: Date(timeIntervalSinceNow: 24 * 60 * 60), reminderType: .none)
    //                        self.addRequest(with: requestIdentifier, content: content, trigger: newTrigger)
    //                    })
    //                default:
    //                    return nil
    //                }
    //            }
    //            self.addRequest(with: requestIdentifier, content: content, trigger: trigger)
    //        }
    //    }
    
    //MARK:- Remove
    
    func removeNotificationRequest(with identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    //MARK:- Configure
    
    private func configureCategories() {
        let stakeCategory = configureCategory(with: .stake,
                                              actionIdentifiers: stakeActionIdentifiers)
        
        notificationCenter.setNotificationCategories([stakeCategory])
    }
    
    private func configureCategory(with identifier: CategoryIdentifier, actionIdentifiers: [ActionIdentifier]) -> UNNotificationCategory {
        let actions = actionIdentifiers.compactMap { UNNotificationAction(identifier: $0.rawValue,
                                                                          title: $0.title,
                                                                          options: []) }
        let intentIdentifiers = actionIdentifiers.compactMap { $0.rawValue }
        
        return UNNotificationCategory(identifier: identifier.rawValue,
                                      actions: actions,
                                      intentIdentifiers: intentIdentifiers,
                                      options: [])
    }
    
    private func configureLocalNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        return content
    }
    
    //MARK:- Support
    
    private func createReminderTrigger(triggerDate: Date) -> UNCalendarNotificationTrigger {
        let triggerDate2: Date = Date(timeIntervalSinceNow: 10)
        let triggerDaily = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate2)
        return UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
    }
    
    // Create and fill request identifiers storage
    private func addRequest(with identifier: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
}

//MARK:- UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        delegate?.userNotificationCenter?(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let requestIdentifier = response.notification.request.identifier
        if let actionIdentifier = ActionIdentifier(rawValue: response.actionIdentifier) {
            switch actionIdentifier {
            case .reminder:
                remindEventCompletion()
                return
            default:
                actionCompletions[requestIdentifier]?
                    .first(where: { identifier, completion in identifier == actionIdentifier })?
                    .completion()
                actionCompletions.removeValue(forKey: requestIdentifier)
            }
        }
        
        openStakeCompletion()
        delegate?.userNotificationCenter?(center, didReceive: response, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        if #available(iOS 12.0, *) {
            delegate?.userNotificationCenter?(center, openSettingsFor: notification)
        } else {
            // Fallback on earlier versions
        }
    }
    
}
