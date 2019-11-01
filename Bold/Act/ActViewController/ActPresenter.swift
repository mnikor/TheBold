//
//  ActPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum ActPresenterInput {
    case showMenu
    case calendar
    case tapPlus
    case allGoals
    case goalItem(goal: Goal)
    case longTapAction
    
    case createDataSource
    case updateDataSource
    case doneEvent(eventID: String?)
    case uploadNewEventsInDataSourceWhenScroll(Int)
    
    case selectEvent(indexPath: IndexPath)
}

protocol ActPresenterInputProtocol {
    func input(_ inputCase: ActPresenterInput)
}

class ActPresenter: PresenterProtocol, ActPresenterInputProtocol {
    
    typealias View = ActViewController
    typealias Interactor = ActInteractor
    typealias Router = ActRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    var goalsSection : CalendarActionItemModel!
    //var goalsDataSource = [Goal]()
    var dataSourceModel = [StakeActionViewModel]()
    var dataSource = [ActDataSourceItem]()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ActPresenterInput) {
        switch inputCase {
        case .createDataSource:
            interactor.input(.createDataSource(success: {[weak self] in
                print("success")
                self?.viewController.tableView.reloadData()
            }))
        case .updateDataSource:
            print("dsfsdfsdfdsfsdf")
        case .doneEvent(eventID: let eventID):
            print("done event")
        case .uploadNewEventsInDataSourceWhenScroll(let index):
            uploadNewEventInDataSourceWhenScrol(count: index)
        
        case .selectEvent(indexPath: let indexPath):
            selectEvent(indexPath: indexPath)
        case .showMenu:
            router.input(.menuShow)
        case .calendar:
            router.input(.calendar)
        case .tapPlus:
            router.input(.tapPlus)
        case .allGoals:
            router.input(.allGoals)
        case .goalItem(goal: let goal):
            let calendarVC = StoryboardScene.Act.calendarActionsListViewController.instantiate()
            calendarVC.presenter.goal = goal
            router.input(.goalItem(calendarVC: calendarVC))
        case .longTapAction:
            let vc = StartActionViewController.createController {
                print("Start")
            }
            router.input(.longTapActionPresentedBy(vc))
        }
        
    }
    
    private func selectEvent(indexPath: IndexPath){
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        
        if case .event(viewModel: let viewModelStake) = item.viewModel {
            
            AlertViewService.shared.input(.editAction(actionID: viewModelStake.event.action?.id, eventID: viewModelStake.event.id, tapAddPlan: {
                print("Ok")
                self.interactor.input(.doneEvent(eventID: viewModelStake.event.id, success: {
                                    self.viewController.tableView.reloadData()
                                }))
            }, tapDelete: {
                print("tapDelete")
                AlertViewService.shared.input(.deleteAction(tapYes: {
                    print("--- Delete ---")
                }))
            }))
            
//            let editActionVC = EditActionPlanViewController.createController(actionID: viewModelStake.event.action?.id, eventID: viewModelStake.event.id, tapOk: { [unowned self] in
//                print("Ok")
//                //self.input(.doneEvent(eventID: <#T##String?#>))
//                //self.input(.doneEvent(eventID: viewModelStake.event.id))
//                self.interactor.input(.doneEvent(eventID: viewModelStake.event.id, success: {
//                    self.viewController.tableView.reloadData()
//                }))
//            }) {
//                print("Delete")
//
//                let vc = BaseAlertViewController.showAlert(type: .dontGiveUp4) {
//                    print("--- Delete ---")
//                }
//
//                vc.presentedBy(self.viewController)
//            }
            
//            router.input(.showEditEvent(vc: editActionVC))
//            print("\(viewModelStake.event)")
        }
    }
    
    private func uploadNewEventInDataSourceWhenScrol(count: Int) {
        interactor.input(.createStakesSection(success: {
            self.viewController.tableView.reloadData()
        }))
    }
    
    private func deleteAction(actionID: String, success: ()->Void) {
        DataSource.shared.deleteAction(actionID: actionID) {
            print("dsfdsf")
        }
    }
    
}

struct ActEntity {
    var type: ActCellType
    var items: Array<Any>?
    var selected: Bool
}
