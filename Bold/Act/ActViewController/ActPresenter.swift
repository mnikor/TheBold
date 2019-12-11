//
//  ActPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
//import RxSwift
//import RxCocoa

//enum ActPresenterInput {
//    case showMenu
//    case calendar
//    case tapPlus
//    case allGoals
//    case goalItem(goal: Goal)
//    case longTapAction(event: Event)
//    
//    case createDataSource
//    case updateDataSource
//    case doneEvent(eventID: String?)
//    case uploadNewEventsInDataSourceWhenScroll(Int)
//    
//    case selectEvent(indexPath: IndexPath)
//    case subscribeToUpdate
//}
//
//protocol ActPresenterInputProtocol {
//    func input(_ inputCase: ActPresenterInput)
//}

class ActPresenter: BaseStakesListPresenter {
    
//    typealias View = ActViewController
//    typealias Interactor = ActInteractor
//    typealias Router = ActRouter
//
//    weak var viewController: View!
//    var interactor: Interactor!
//    var router: Router!
    
//    let disposeBag = DisposeBag()
//    var goalsSection : CalendarModelType!
//    //var goalsDataSource = [Goal]()
//    var dataSourceModel = [StakeActionViewModel]()
//    var dataSource = [ActDataSourceViewModel]()
//
//    required init(view: View) {
//        self.viewController = view
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//
//    }
//
//    func input(_ inputCase: ActPresenterInput) {
//        switch inputCase {
//        case .createDataSource:
//            interactor.input(.createDataSource(success: {[weak self] in
//                print("success")
//                self?.viewController.tableView.reloadData()
//            }))
//        case .updateDataSource:
//            print("dsfsdfsdfdsfsdf")
//        case .doneEvent(eventID: let eventID):
//            print("done event")
//        case .uploadNewEventsInDataSourceWhenScroll(let index):
//            uploadNewEventInDataSourceWhenScrol(count: index)
//
//        case .selectEvent(indexPath: let indexPath):
//            selectEvent(indexPath: indexPath)
//        case .showMenu:
//            router.input(.menuShow)
//        case .calendar:
//            router.input(.calendar)
//        case .tapPlus:
//            router.input(.tapPlus)
//        case .allGoals:
//            router.input(.allGoals)
//        case .goalItem(goal: let goal):
//            let calendarVC = StoryboardScene.Act.calendarActionsListViewController.instantiate()
//            calendarVC.presenter.goal = goal
//            router.input(.goalItem(calendarVC: calendarVC))
//        case .longTapAction(event: let event):
//            longTapAction(event: event)
//        case .subscribeToUpdate:
//            subscribeToUpdate()
//        }
//    }
//
//    private func longTapAction(event: Event) {
//
//        if let content = event.action?.content {
//
//            AlertViewService.shared.input(.startActionForContent(tapStartNow: {
//                print("Start content - \(content)")
//            }))
//        }
//    }
//
//    private func selectEvent(indexPath: IndexPath){
//
//        let item = dataSource[indexPath.section].items[indexPath.row]
//
//        if case .event(viewModel: let viewModelStake) = item {
//
//            let points = viewModelStake.event.calculatePoints
//
//            AlertViewService.shared.input(.editAction(actionID: viewModelStake.event.action?.id, eventID: viewModelStake.event.id, points: points, tapAddPlan: {
//                //self.tapDoneEvent(eventID: viewModelStake.event.id!)
//            }, tapDelete: {
//                //self.deleteAction(actionID: viewModelStake.event.action!.id!)
//            }))
//        }
//    }
//
//    private func uploadNewEventInDataSourceWhenScrol(count: Int) {
//        interactor.input(.createStakesSection(success: {
//            self.viewController.tableView.reloadData()
//        }))
//    }
    
//    private func tapDoneEvent(eventID: String) {
//        DataSource.shared.doneEvent(eventID: eventID) {
//            print("Done Event")
//        }
//    }
//    
//    private func deleteAction(actionID: String) {
//        AlertViewService.shared.input(.deleteAction(tapYes: {
//            
//            LevelOfMasteryService.shared.input(.addPoints(points: PointsForAction.deleteAction))
//            DataSource.shared.deleteAction(actionID: actionID) {
//                print("--- Delete ---")
//            }
//        }))
//    }
//
//     private func subscribeToUpdate() {
//
//        DataSource.shared.changeContext.subscribe(onNext: { (_) in
//            self.input(.createDataSource)
//        }).disposed(by: disposeBag)
//    }
    
}
