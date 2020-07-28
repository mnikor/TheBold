//
//  HomePresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import StoreKit

enum HomePresenterInput {
    case prepareDataSource(([ActivityViewModel]) -> Void)
    case menuShow
    case actionAll(HomeActionsTypeCell)
    case actionItem(ActivityViewModel, Int)
    case unlockBoldManifest
    case showBoldManifest
    case createGoal
    case subscribeForUpdates
    case goalItem(Goal)
    case editGoal(Goal)
    case showLevelOfMastery
}

protocol HomePresenterInputProtocol {
    func input(_ inputCase: HomePresenterInput)
    func succesfullPayment()
}

class HomePresenter: PresenterProtocol, HomePresenterInputProtocol {
    
    typealias View = HomeViewController
    typealias Interactor = HomeInteractor
    typealias Router = HomeRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    private var disposeBag = DisposeBag()
    
    private var goalToUnlock: Goal?
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: HomePresenterInput) {
        
        switch inputCase {
            case .prepareDataSource(let completion):
                interactor.input(.prepareDataSource(completion))
            case .menuShow:
                router.input(.menuShow)
            case .actionAll(let type):
                router.input(.actionAll(type))
            case .actionItem(let viewModel, let index):
                actionItem(viewModel: viewModel, at: index)
            case .unlockBoldManifest:
                router.input(.unlockBoldManifest)
            case .showBoldManifest:
                router.input(.showBoldManifest)
            case .createGoal:
                router.input(.createGoal)
            case .subscribeForUpdates:
                subscribeForUpdates()
            case .goalItem(let goal):
                if goal.status == StatusType.locked.rawValue {
                    /// Price to unlock the goal
                    var stake = 0
                    /// Get goal's actions
                    let actions = DataSource.shared.getActions(for: goal)
                    /// Get first stake with status failed or unlock and stake
                    for action in actions {
                        if action.status > 4 {
                            if action.stake > 0 {
                                stake = Int(action.stake.rounded())
                                break
                            }
                        }
                    }
                    /// Bottom alert view with unlock action
                    AlertViewService.shared.input(.missedYourActionLock(tapUnlock: { [weak self] in
                        guard let ss = self else { return }
                        /// Start loader
                        ss.viewController.startLoader()
                        
                        /// Select correct SKProduct
                        let baseStakeId = "com.nikonorov.newBold.Stake"
                        let products = IAPProducts.shared.products
                        var currentStake: SKProduct?
                        
                        for product in products {
                            if product.productIdentifier == baseStakeId + String(stake) {
                                currentStake = product
                                break
                            }
                        }
                        
                        /// After we get required stake product we should launch in-app
                        if let product = currentStake {
                            ss.goalToUnlock = goal
                            IAPProducts.shared.store.buyProduct(product)
                        } else {
                            ss.goalToUnlock = goal
                            ss.unlockGoal()
                            print("We don't have such product: Stake\(stake)")
                        }
                        LevelOfMasteryService.shared.input(.unlockGoal(goalID: goal.id!))
                    }))
                } else { router.input(.goalItem(goal)) }
            case .editGoal(let goal):
                if goal.status == StatusType.locked.rawValue {
                    AlertViewService.shared.input(.missedYourActionLock(tapUnlock: {
                        
                        LevelOfMasteryService.shared.input(.unlockGoal(goalID: goal.id!))
                    }))
                }else {
                    let vc = EditGoalViewController.createController(goalID: goal.id) {
                        print("tap edit goal ok")
                    }
                    router.input(.longTapGoalPresentedBy(vc))
            }
            case .showLevelOfMastery:
                router.input(.showLevelOfMastery)
        }
    }
    
    private func actionItem(viewModel: ActivityViewModel, at index: Int) {
        interactor.input(.getFeelType(type: viewModel.type, index: index, completion: { [weak self] feelType in
            guard let feelType = feelType else { return }
            self?.router.input(.actionItem(feelType))
        }))
    }
    
    private func subscribeForUpdates() {
        DataSource.shared.changeContext.subscribe(onNext: {[weak self] (_) in
            self?.viewController.input(.goalsUpdated)
        }).disposed(by: disposeBag)
    }
    
    func succesfullPayment() {
        //TODO: Unlock goal with goalToUnlock
        unlockGoal()
        router.showThankForPaymentController()
    }
    
    private func unlockGoal() {
        
        guard let goal = goalToUnlock, let goalId = goal.id else { return }
        
        let events = DataSource.shared.eventOfGoal(goalID: goalId)
        
        goal.status = StatusType.wait.rawValue
        
        for event in events {
            if event.status > 4 {
                DataSource.shared.updateEvent(eventID: event.id!) {
                    print("Event updated successfully!")
                }
                
                let actions = DataSource.shared.getActions(for: goal)
                
                for action in actions {
                    if action.status > 4 {
                        action.status = StatusType.failed.rawValue
                    }
                }
                
            }
        }
        
        do {
            try DataSource.shared.viewContext.save()
        } catch {
            print("Can't save main context")
        }
        
        DataSource.shared.saveBackgroundContext()
        
        viewController.stopLoader()
        
    }
    
}


