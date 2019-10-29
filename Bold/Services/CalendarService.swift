//
//  CalendarService.swift
//  Bold
//
//  Created by Admin on 9/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import EventKit

typealias EventsCalendarManagerResponse = (_ result: ResultCustomError<Bool, CalendarCustomError>) -> Void

class CalendarService {
    
    static var shared = CalendarService()
    
    private var eventStore: EKEventStore
    
    private init() {
        eventStore = EKEventStore()
    }
    
    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: .event,
                                 completion: completion)
    }
    
    private func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    private func generateEvent(from event: CalendarEvent) -> EKEvent {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        newEvent.title = event.name
        newEvent.startDate = event.startDate
        newEvent.endDate = event.endDate
        return newEvent
    }
    
    private func eventAlreadyExists(_ event: EKEvent) -> Bool {
        let predicate = eventStore.predicateForEvents(withStart: event.startDate, end: event.endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        return existingEvents.contains(where: { ($0.title == event.title) && ($0.startDate == event.startDate) && ($0.endDate == event.endDate) })
    }
    
    private func update(event: EKEvent, with newEventData: CalendarEvent) {
        event.title = newEventData.name
        event.startDate = newEventData.startDate
        event.endDate = newEventData.endDate
    }
    
    private func add(event: CalendarEvent, completion: @escaping EventsCalendarManagerResponse) {
        let ekEvent = generateEvent(from: event)
        if !eventAlreadyExists(ekEvent) {
            do {
                try eventStore.save(ekEvent, span: .thisEvent, commit: true)
                completion(.success(true))
            } catch {
                completion(.failure(.eventNotAddedToCalendar))
            }
        } else {
            completion(.failure(.eventAlreadyExistsInCalendar))
        }
    }
    
    private func update(event: EKEvent, newEventData: CalendarEvent, completion: @escaping EventsCalendarManagerResponse) {
        update(event: event, with: newEventData)
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            completion(.success(true))
        } catch {
            completion(.failure(.eventNotAddedToCalendar))
        }
    }
    
    private func remove(event: EKEvent, completion: @escaping EventsCalendarManagerResponse) {
        do {
            try eventStore.remove(event, span: .thisEvent, commit: true)
            completion(.success(true))
        } catch {
            completion(.failure(.eventNotRemovedFromCalendar))
        }
    }
    
    func addEvent(_ event: CalendarEvent, completion: @escaping EventsCalendarManagerResponse) {
        switch getAuthorizationStatus() {
        case .authorized:
            add(event: event, completion: completion)
            
        case .notDetermined:
            requestAccess { [unowned self] (accessGranted, _) in
                if accessGranted {
                    self.add(event: event, completion: completion)
                } else {
                    completion(.failure(.calendarAccessDeniedOrRestricted))
                }
            }
            
        case .denied, .restricted:
            completion(.failure(.calendarAccessDeniedOrRestricted))
        @unknown default:
            break
        }
    }
    
    func updateEvent(with identifier: String, newEventData: CalendarEvent, completion: @escaping EventsCalendarManagerResponse) {
        switch getAuthorizationStatus() {
        case .authorized:
            guard let event = eventStore.event(withIdentifier: identifier)
                else {
                    completion(.failure(.eventDoesntExistsInCalendar))
                    return
            }
            update(event: event, newEventData: newEventData, completion: completion)
            
        case .notDetermined:
            requestAccess { [unowned self] (accessGranted, _) in
                if accessGranted {
                    guard let event = self.eventStore.event(withIdentifier: identifier)
                        else {
                            completion(.failure(.eventDoesntExistsInCalendar))
                            return
                    }
                    self.update(event: event, newEventData: newEventData, completion: completion)
                } else {
                    completion(.failure(.calendarAccessDeniedOrRestricted))
                }
            }
        case .denied, .restricted:
            completion(.failure(.calendarAccessDeniedOrRestricted))
        }
    }
    
    func removeEvent(with identifier: String, completion: @escaping EventsCalendarManagerResponse) {
        switch getAuthorizationStatus() {
        case .authorized:
            guard let event = eventStore.event(withIdentifier: identifier)
                else {
                    completion(.failure(.eventDoesntExistsInCalendar))
                    return
            }
            remove(event: event, completion: completion)
            
        case .notDetermined:
            requestAccess { [unowned self] (accessGranted, _) in
                if accessGranted {
                    guard let event = self.eventStore.event(withIdentifier: identifier)
                        else {
                            completion(.failure(.eventNotAddedToCalendar))
                            return
                    }
                    self.remove(event: event, completion: completion)
                } else {
                    completion(.failure(.calendarAccessDeniedOrRestricted))
                }
            }
            
        case .denied, .restricted:
            completion(.failure(.calendarAccessDeniedOrRestricted))
        @unknown default:
            break
        }
    }
    
}
