//
//  ActPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActPresenterInput {
    case showMenu
    case calendar
    case tapPlus
    case allGoals
    case goalItem
    case longTapAction
    
    case createDataSource
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
        case .goalItem:
            router.input(.goalItem)
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
            
            let editActionVC = EditActionPlanViewController.createController(tapOk: {
                print("Ok")
            }) {
                print("Delete")
            }
            
            router.input(.showEditEvent(vc: editActionVC))
            print("\(viewModelStake.event)")
        }
    }
    
    private func uploadNewEventInDataSourceWhenScrol(count: Int) {
        interactor.input(.createStakesSection(success: {
            self.viewController.tableView.reloadData()
        }))
    }
    
}

struct ActEntity {
    var type: ActCellType
    var items: Array<Any>?
    var selected: Bool
}
