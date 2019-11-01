//
//  AlertViewService.swift
//  Bold
//
//  Created by Alexander Kovalov on 10/30/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

struct PointsForAction {
    static let moveToLaterDate : Int = -10
    static let congratulationsGoal : Int = 50
    static let congratulationsAction : Int = 50
    static let deleteGoal : Int = -50
    static let deleteAction : Int = -10
    static let deleteStake : Int = -10
}

enum AlertViewServiceInput {
    case congratulationsAction(tapGet: VoidCallback)
    case congratulationsGoal(tapGet: VoidCallback)
    case moveToLaterDate(tapYes: VoidCallback)
    case missedYourActionLock(tapUnlock: VoidCallback)
    case missedYourAction(tapOkay: VoidCallback)
    case deleteGoal(tapYes: VoidCallback)
    case deleteAction(tapYes: VoidCallback)
    case deleteStake(tapYes: VoidCallback)
    
    case addAction(tapAddPlan: VoidCallback)
    case editAction(actionID: String?, eventID: String?, tapAddPlan: VoidCallback, tapDelete: VoidCallback)
    
    case startActionForContent(tapStartNow: VoidCallback)
    case startActionForContentOrDelete(item: DownloadsEntity?, tapAddPlan: VoidCallback, tapDelete: VoidCallback)
    
    case dateAlert(type:DateAlertType, currentDate:Date?, startDate: Date?, endDate:Date?, tapConfirm: Callback<Date>)
    case monthYearAlert(currentDate:Date, tapConfirm: Callback<Date>)
}

protocol AlertViewServiceInputProtocol {
    func input(_ inputCase: AlertViewServiceInput)
}

class AlertViewService: NSObject, AlertViewServiceInputProtocol {
    
    static let shared = AlertViewService()
    
    func input(_ inputCase: AlertViewServiceInput) {
        
        switch inputCase {
        case .congratulationsAction(tapGet: let tapGet):
            createViewController(type: randomAlert(types: [.congratulationsAction1, .congratulationsAction2]), tapOk: tapGet)
        case .congratulationsGoal(tapGet: let tapGet):
            createViewController(type: randomAlert(types: [.goalIsAchievedMadeImportantDecision, .goalIsAchievedAchievedYourGoal]), tapOk: tapGet)
        case .moveToLaterDate(tapYes: let tapYes):
            createViewController(type: .dontGiveUpMoveToLaterDate, tapOk: tapYes)
        case .missedYourActionLock(tapUnlock: let tapUnlock):
            createViewController(type: .youveMissedYourActionLock, tapOk: tapUnlock)
        case .missedYourAction(tapOkay: let tapOkay):
            createViewController(type: .youveMissedYourAction, tapOk: tapOkay)
        case .deleteGoal(tapYes: let tapYes):
            createViewController(type: .dontGiveUpDeleteGoal, tapOk: tapYes)
        case .deleteAction(tapYes: let tapYes):
            createViewController(type: randomAlert(types: [.dontGiveUpDeleteAction, .dontGiveUpDeleteThisTask]), tapOk: tapYes)
        case .deleteStake(tapYes: let tapYes):
            createViewController(type: .dontGiveUpDeleteStake, tapOk: tapYes)
            
        case .addAction(tapAddPlan: let tapAddPlan):
            createAddAction(tapAdd: tapAddPlan)
        case .editAction(actionID: let actionID, eventID: let eventID, tapAddPlan: let tapAddPlan, tapDelete: let tapDelete):
            editAction(actionID: actionID, eventID: eventID, tapOk: tapAddPlan, tapDelete: tapDelete)
            
        case .startActionForContent(tapStartNow: let tapStartNow):
            startActionForContent(tapStartNow: tapStartNow)
        case .startActionForContentOrDelete(item: let item, tapAddPlan: let tapAddPlan, tapDelete: let tapDelete):
            startActionForContentOrDelete(item: item, tapAddPlan: tapAddPlan, tapDelete: tapDelete)
            
        case .dateAlert(type: let type, currentDate: let currentDate, startDate: let startDate, endDate: let endDate, tapConfirm: let tapConfirm):
            dateAlert(type: type, currentDate: currentDate, startDate: startDate, endDate: endDate, tapConfirm: tapConfirm)
        case .monthYearAlert(currentDate: let currentDate, tapConfirm: let tapConfirm):
            monthYearAlert(currentDate: currentDate, tapConfirm: tapConfirm)
        }
    }
    
    // MARK: - Support Function
    
    private func randomAlert(types:[BoldAlertType]) -> BoldAlertType {
        return types[Int(arc4random_uniform(UInt32(types.count)))]
    }
    
    private func showAlertController(_ viewcontroller: UIViewController) {
        
        UIApplication.shared.keyWindow?.rootViewController?.addChild(viewcontroller)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(viewcontroller.view)
        
        viewcontroller.view.setNeedsLayout()
        viewcontroller.view.layoutIfNeeded()
    }
    
    private func showAlertControllerWithNavigation(_ viewcontroller: UIViewController) {
        
        let navVC = UINavigationController(rootViewController: viewcontroller)
        UIApplication.shared.keyWindow?.rootViewController?.addChild(navVC)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(navVC.view)
        
        viewcontroller.view.setNeedsLayout()
        viewcontroller.view.layoutIfNeeded()
    }
    
    // MARK: - Create Functions
    
    private func createViewController(type: BoldAlertType, tapOk: @escaping VoidCallback) {
        
        let alertVC = BaseAlertViewController.showAlert(type: type, tapOk: tapOk)
        showAlertController(alertVC)
    }
    
    private func createAddAction(tapAdd: @escaping VoidCallback) {
        
        let addVC = AddActionPlanViewController.createController(tapOk: tapAdd)
        showAlertController(addVC)
    }
    
    private func editAction(actionID: String?, eventID: String?, tapOk: @escaping VoidCallback, tapDelete: @escaping VoidCallback) {
        
        let editVC = EditActionPlanViewController.createController(actionID: actionID, eventID: eventID, tapOk: tapOk, tapDelete: tapDelete)
        showAlertControllerWithNavigation(editVC)
    }
    
    private func startActionForContent(tapStartNow: @escaping VoidCallback) {
        
        let actionContentVC = StartActionViewController.createController(tapOk: tapStartNow)
        showAlertController(actionContentVC)
    }
    
    private func startActionForContentOrDelete(item: DownloadsEntity?, tapAddPlan: @escaping VoidCallback, tapDelete: @escaping VoidCallback) {
        
        let actionContentVC = DownloadsActionViewController.createController(item: item, tapAddPlan: tapAddPlan, tapDelete: tapDelete)
        showAlertController(actionContentVC)
    }
    
    private func dateAlert(type:DateAlertType, currentDate:Date?, startDate: Date?, endDate:Date?, tapConfirm: @escaping Callback<Date>) {
        
        let dateVC = DateAlertViewController.createController(type: type, currentDate: currentDate, startDate: startDate, endDate: endDate, tapConfirm: tapConfirm)
        showAlertController(dateVC)
    }
    
    private func monthYearAlert(currentDate:Date, tapConfirm: @escaping Callback<Date>) {
        
        let monthYearVC = YearMonthAlertViewController.createController(currentDate: currentDate, tapConfirm: tapConfirm)
        showAlertController(monthYearVC)
    }
    
}
