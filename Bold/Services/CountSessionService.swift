//
//  CalculateSessionService.swift
//  Bold
//
//  Created by Alexander Kovalov on 31.10.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum CalulateSessionType {
    case forAudio(totalDuration: TimeInterval)
    case forRead(contentHeight: CGFloat, offset: CGFloat)
}

protocol CountSessionServiceProtocol: class {
    func input(_ inputCase: CalulateSessionType)
}

class CountSessionService : CountSessionServiceProtocol {
    
    private var content: ActivityContent
    private var isIncrease: Bool = false
    
    init(content: ActivityContent) {
        self.content = content
    }
    
    func input(_ inputCase: CalulateSessionType) {
        
        switch inputCase {
        case .forAudio(let totalDuration):
            playerStoped(with: totalDuration)
        case .forRead(let contentHeight, let offset):
            readContent(contentHeight: contentHeight, offset: offset)
        }
    }
    
    private func playerStoped(with totalDuration: TimeInterval) {
        
        let durationInMinutes = Int(totalDuration / 60)
//        boldnessChanged(duration: durationInMinutes)
        
        if Double(content.durtionRead) * 60 * 0.7 <= totalDuration {
            increaseBoldnessCounter()
        }
        
        switch content.type {
        case .meditation:
            if durationInMinutes >= 7 {
                updatePoints()
            }
        case .hypnosis:
            if durationInMinutes >= 20 {
                updatePoints()
            }
        case .peptalk:
            if totalDuration >= 3 {
                updatePoints()
            }
        case .story:
            // TODO: - story duration
            break
        case .lesson, .quote:
            break
        }
    }
    
    private func readContent(contentHeight: CGFloat, offset: CGFloat) {
        
        let percent = offset / contentHeight
        if percent >= 0.7 {
            if isIncrease == false {
                isIncrease = true
                increaseBoldnessCounter()
            }
        }
    }
    
//    private func boldnessChanged(duration: Int) {
//        SettingsService.shared.boldness += duration
//    }
    
    private func updatePoints() {
        LevelOfMasteryService.shared.input(.addPoints(points: 10))
    }
    
    private func increaseBoldnessCounter() {
        SettingsService.shared.boldness += 1
    }
}
