//
//  PointBold.swift
//  Bold
//
//  Created by Alexander Kovalov on 04.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

@objc protocol SSPointChangeValueDelegate {
    
    func pointChanged(withAnimation: Bool)
}


class PointBold {
    
    // MARK: Delegate
    weak var delegate: SSPointChangeValueDelegate?
    
    private var userPoint : Int32 = DataSource.shared.readUser()?.levelOfMasteryPoints ?? 0
    
    // MARK: Public Properties
    var currentPoints: Int {
        get {
            return Int(userPoint)
        }
        set {
            userPoint = Int32(newValue)
        }
    }
    
    
    // MARK: Public funcs
    
    func updatePointsLabel(withAnimation: Bool) {
        delegate?.pointChanged(withAnimation: withAnimation)
    }
    
    func getCurrentPoints() -> String {
        return currentPoints < 0 ? currentPoints.description : "+" + currentPoints.description
    }
    
    func getPointsFor(stake: Float) -> String {
        return "+" + calculatePointsFor(stake: stake).description
    }
    
    func calculatePointsFor(stake: Float) -> Int {
        return stake == 0.0 ? 5 : Int(stake + 6.0)
    }
    
    func add(_ points: Int) {
        
        // Add points
        currentPoints += points
        delegate?.pointChanged(withAnimation: true)
        
        // Lesson tracking
//        if let trackingLesson = SSLessonsManager.instance.trackingLesson {
//            trackingLesson.setPoints(trackingLesson.points + Float(points))
//        }
        
        // Show alert when first points earned
//        let userDefaults = UserDefaults.standard
//        let key = SSConstants.keys.kFirstEarnPoint.rawValue
        
//        if !userDefaults.bool(forKey: key) {
//
//            SSMessageManager.showCustomAlertWith(message: .firstPointsEarned, onViewController: nil)
//            userDefaults.set(true, forKey: key)
//        }
    }
    
    func deduct(_ points: Int) {
        
        currentPoints -= points
        delegate?.pointChanged(withAnimation: true)
    }
}
