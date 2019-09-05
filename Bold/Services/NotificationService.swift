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
}

class NotificationService: NSObject {
    static let shared = NotificationService()
    
    weak var delegate: UNUserNotificationCenterDelegate?
    
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
    }
    
    func updateDeviceToken(_ token: Data) {
//        Messaging.messaging().apnsToken = token
//        if let fcmToken = Messaging.messaging().fcmToken {
//            AppSettings.shared.pushToken = fcmToken
//        }
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
        case .onTheDay:
            triggerDate = date
        }
        var triggerDaily = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
        triggerDaily.hour = 12
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
