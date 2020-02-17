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

enum RepeatType {
    case everyDay
    case weekdays([DayWeekType])
}

enum ReminderType {
    case beforeTheDay
    case onTheDay
    case none
}

enum StandardNotification {
    case actionCompleteWithStake
    case actionCompleteWithoutStake
    case actionWasNotAccomplished
    case goalAchieved
    case goalDeleted(completion: (Bool) -> Void)
    case actionDeleted(completion: (Bool) -> Void)
    case reminderOneDayBefore(actionTitle: String, date: Date, type: ReminderType)
    case reminderOnDay(actionTitle: String, stake: Int, date: Date, type: ReminderType)
    case levelOfMasteryAchieved(newLevelTitle: String)
    case actionsAndContentCompleted
    
    var body: String {
        switch self {
        case .actionCompleteWithStake:
            return "Congratulations! You have completed your action, saved your stake and earned points. Keep crushing your action plan!!!"
        case .actionCompleteWithoutStake:
            return "Congratulations! You have completed your action and earned points. Keep crushing your action plan!!!"
        case .actionWasNotAccomplished:
            return "You've missed your action. Don’t give up, keep going!"
        case .goalAchieved:
            return "Fantastic! You have achieved your goal. Congratulations, you get additional points!!!"
        case .goalDeleted:
            return "Sometimes goals become irrelevant! Confirm deletion (-50 points)"
        case .actionDeleted:
            return "Sometimes actions become irrelevant as we adapt our strategy! Confirm deletion (-10 points)"
        case .reminderOneDayBefore(actionTitle: let title, _, _):
            return "You have an action due to be completed tomorrow… \(title)"
        case .reminderOnDay(actionTitle: let title, stake: let stake, _, _):
            return "You have an action due to be completed today… \(title). With a stake of $\(stake) Make sure to complete it to win your stake!"
        case .levelOfMasteryAchieved(newLevelTitle: let title):
            return "Incredible, you just moved to another Level of Mastery! Now you are \(title) Keep mastering yourself."
        case .actionsAndContentCompleted:
            return "Are you finding The Bold app helpful?"
        }
    }
}

private enum CategoryIdentifier: String {
    case yesNo = "y/n"
    case rating
}

enum ActionIdentifier: String {
    case yes
    case no
    case rate
    case feedback
    case reminder
    
    var title: String {
        switch self {
        case .yes:
            return "Yes"
        case .no:
            return "No"
        case .rate:
            return "Yes - rate it"
        case .feedback:
            return "No, send feedback"
        case .reminder:
            return "Remind me later"
        }
    }
}

typealias ActionCompletion = (actionIdentifier: ActionIdentifier, completion: () -> Void)

class NotificationService: NSObject {
    static let shared = NotificationService()
    
    weak var delegate: UNUserNotificationCenterDelegate?
    
    private var actionCompletions: [String: [ActionCompletion]] = [:]
    private let yesNoActionIdentifiers: [ActionIdentifier] = [.yes, .no]
    private let ratingActionIdentifiers: [ActionIdentifier] = [.rate, .feedback, .reminder]
    
    private let rateAppCompletion: () -> Void = {
        print("rate app")
    }
    
    private let sendFeedbackCompletion: () -> Void = {
        print("send feedback")
    }
    
    private override init() {
        super.init()
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        configureCategories()
    }
    
    func updateDeviceToken(_ token: Data) {
//        Messaging.messaging().apnsToken = token
//        if let fcmToken = Messaging.messaging().fcmToken {
//            AppSettings.shared.pushToken = fcmToken
//        }
    }
    
    func createStandardNotification(_ notification: StandardNotification) {
        switch notification {
        case .actionDeleted(completion: let completion):
            createYesNoNotification(message: notification.body, completion: completion)
        case .goalDeleted(completion: let completion):
            createYesNoNotification(message: notification.body, completion: completion)
        case .actionsAndContentCompleted:
            createRatingNotification(message: notification.body)
        case .reminderOnDay(actionTitle: let title, stake: _, date: let date, type: let type):
            createReminder(title: title, body: notification.body, date: date, reminderType: type, identifier: nil)
        case .reminderOneDayBefore(actionTitle: let title, date: let date, type: let type):
            createReminder(title: title, body: notification.body, date: date, reminderType: type, identifier: nil)
        default:
            createReminder(title: "Bold", body: notification.body, date: Date(timeIntervalSinceNow: 5), reminderType: .none, identifier: nil)
        }
    }
    
    func getLocalNotificationStatus(_ completion: @escaping (NotificationAuthorizationStatus) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
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
    
    func createRepeatingNotification(title: String, body: String, repeatType: RepeatType, identifier: String?) {
        getLocalNotificationStatus { [weak self] status in
            guard let self = self,
                status == .authorized
                else { return }
            let content = self.configureLocalNotificationContent(title: title, body: body)
            let triggers: [UNCalendarNotificationTrigger]
            switch repeatType {
            case .everyDay:
                triggers = self.createEveryDayReminder(for: content)
            case .weekdays(let weekdays):
                triggers = self.createWeekdaysReminder(for: content, with: weekdays)
            }
            for trigger in triggers {
                self.addRequest(with: identifier ?? UUID().uuidString, content: content, trigger: trigger)
            }
        }
    }
    
    func createReminder(title: String, body: String, date: Date, reminderType: ReminderType, identifier: String?) {
        getLocalNotificationStatus { [weak self] status in
            guard let self = self,
                status == .authorized
                else { return }
            let content = self.configureLocalNotificationContent(title: title, body: body)
            let trigger = self.createReminderTrigger(date: date, reminderType: reminderType)
            self.addRequest(with: identifier ?? UUID().uuidString, content: content, trigger: trigger)
        }
    }
    
    func removeNotificationRequest(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier] )
    }
    
    private func createYesNoNotification(message: String, completion: @escaping (Bool) -> Void) {
        getLocalNotificationStatus { [weak self] status in
            guard let self = self,
                status == .authorized
                else { return }
            let content = self.configureLocalNotificationContent(title: "", body: message)
            let trigger = self.createReminderTrigger(date: Date(timeIntervalSinceNow: 2), reminderType: .none)
            content.categoryIdentifier = CategoryIdentifier.yesNo.rawValue
            let requestIdentifier = UUID().uuidString
            self.actionCompletions[requestIdentifier] = self.yesNoActionIdentifiers.compactMap { action in
                let actionCompletion: () -> Void = { completion( action != .no) }
                return (action, actionCompletion)
            }
            self.addRequest(with: requestIdentifier, content: content, trigger: trigger)
            completion(true)
        }
    }
    
    private func createRatingNotification(message: String ) {
        getLocalNotificationStatus { [weak self] status in
            guard let self = self,
                status == .authorized
                else { return }
            let content = self.configureLocalNotificationContent(title: "", body: message)
            let trigger = self.createReminderTrigger(date: Date(timeIntervalSinceNow: 2), reminderType: .none)
            content.categoryIdentifier = CategoryIdentifier.rating.rawValue
            let requestIdentifier = UUID().uuidString
            self.actionCompletions[requestIdentifier] = self.ratingActionIdentifiers.compactMap { action in
                switch action {
                case .reminder:
                    return (action, {
                        let newTrigger = self.createReminderTrigger(date: Date(timeIntervalSinceNow: 24 * 60 * 60), reminderType: .none)
                        self.addRequest(with: requestIdentifier, content: content, trigger: newTrigger)
                    })
                default:
                    return nil
                }
            }
            self.addRequest(with: requestIdentifier, content: content, trigger: trigger)
        }
    }
    
    private func configureCategories() {
        let yesNoCategory = configureCategory(with: .yesNo,
                                              actionIdentifiers: yesNoActionIdentifiers)
        let ratingCategory = configureCategory(with: .rating,
                                               actionIdentifiers: ratingActionIdentifiers)
        
        UNUserNotificationCenter.current().setNotificationCategories([yesNoCategory, ratingCategory])
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
    
    private func createEveryDayReminder(for content: UNMutableNotificationContent) -> [UNCalendarNotificationTrigger] {
        let triggerDaily = DateComponents(hour: 14, minute: 20, second: 0)
        return [UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)]
    }
    
    private func createWeekdaysReminder(for content: UNMutableNotificationContent, with weekdays: [DayWeekType]) -> [UNCalendarNotificationTrigger] {
        return weekdays.compactMap { weekday -> UNCalendarNotificationTrigger in
            let triggerDaily = DateComponents(hour: 12, minute: 0, second: 0, weekday: weekday.weekdayIndex)
            return UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        }
    }
    
    private func createReminderTrigger(date: Date, reminderType: ReminderType) -> UNCalendarNotificationTrigger {
        let triggerDate: Date
        switch reminderType {
        case .beforeTheDay:
            triggerDate = Date(timeIntervalSinceNow: date.timeIntervalSinceNow - (24 * 60 * 60))
        case .onTheDay, .none:
            triggerDate = date
        }
        var triggerDaily = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
        triggerDaily.hour = reminderType != .none ? 12 : triggerDaily.hour
        return UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
    }
    
    // FIXME: - Create and fill request identifiers storage
    private func addRequest(with identifier: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        delegate?.userNotificationCenter?(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let requestIdentifier = response.notification.request.identifier
        if let actionIdentifier = ActionIdentifier(rawValue: response.actionIdentifier) {
            switch actionIdentifier {
            case .rate:
                rateAppCompletion()
                return
            case .feedback:
                sendFeedbackCompletion()
                return
            default:
                actionCompletions[requestIdentifier]?
                    .first(where: { identifier, completion in identifier == actionIdentifier })?
                    .completion()
                actionCompletions.removeValue(forKey: requestIdentifier)
            }
        }
        
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
