//
//  BaseStakesListPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import StoreKit

enum BaseStakesDataSourceType {
    case all
    case forGoal
    case archive
    
    func startDatePeriod() -> Date {
        switch self {
        case .all:
            return Date()
        case .forGoal:
            return Date()
        case .archive:
            return DataSource.shared.goalsStartDateForArchieve() ?? Date()
        }
    }
    
    func endDatePeriod() -> Date? {
        switch self {
        case .all:
            return DataSource.shared.goalsEndDateForAll()
        case .forGoal:
            return nil
        case .archive:
            return Date()
        }
    }
    
}

enum BaseStakesListInputPresenter {
    //создаем базовый датасорс
    case createDataSource(goalID: String?)
    //подгрузка нового контента при скроле таблицы
    case uploadNewEventsInDataSourceWhenScroll(Int)
    //подгрузка нового контента при скроле календаря
    case scrollToMonthInCalendar(Date)
    //выбираем месяц для показа из шапки календаря
    case selectCalendarSection(date: Date)
    //создаем экшен
    case createAction
    
    //показываем - скрываем календарь в начале таблицы
    case calendarHeader(ActHeaderType)
    //показываем алерт выбора месяца и года для календаря
    case yearMonthAlert(date: Date)
    // подписываемся на обновления в базе данных
    case subscribeToUpdate
    
    //переходим на контроллер отображения всех экшенов конкретного гола
    case goalItem(goal: Goal)
    //отслеживаем долгое нажатие на ячейке
    case longTapAction(event: Event)
    //по нажатию на экшен показываем алерт редактирования или перевода в статус сделано
    case selectEvent(indexPath: IndexPath)
    //показываем алерт редактирования цели
    case longTapGoal(goal: Goal)
    
    case tapPlus
    case createGoal
}

protocol BaseStakesListInputPresenterProtocol {
    func input(_ inputCase: BaseStakesListInputPresenter)
    func succesfullPayment()
}

class BaseStakesListPresenter: PresenterProtocol, BaseStakesListInputPresenterProtocol {
    
    typealias View = BaseStakesListViewController
    typealias Interactor = BaseStakesListInteractor
    typealias Router = BaseStakesListRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    let disposeBag = DisposeBag()
    
    var currentDate : Date! {
        didSet(newValue) {
            print("newValue currentDate = \(String(describing: newValue))")
        }
    }
    
    var type: BaseStakesDataSourceType!
    
    var goalID : String!
    var selectedContent: ActivityContent?
    
    var calendarDataSource = Set<Date>()
    var dataSource = [ActDataSourceViewModel]() {
        didSet {
            print("newValue dataSource")
        }
    }
    var baseDataSource = [ActDataSourceViewModel]()
    var calendarSection: ActDataSourceViewModel!
    var goalSection: ActDataSourceViewModel! {
        didSet {
            print("newValue goalSection")
        }
    }
    var rangeDate: RangeDatePeriod!
    var goal: Goal!
    var goalToUnlock: Goal?
    var isCalendarVisible: Bool = false
    
    var isLoadContent: Bool = false
    var isNoMoreDownloadContent: Bool = false
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: BaseStakesListInputPresenter) {
        
        switch inputCase {
        case .createDataSource(goalID: let goalID):
            createDataSource(goalID: goalID)
        case .uploadNewEventsInDataSourceWhenScroll(let count):
            uploadNewEventInDataSourceWhenScroll(count: count)
        case .selectCalendarSection(date: let date):
            configDataSource(date: date)
        case .scrollToMonthInCalendar(let date):
            checkingMonthWhenScroll(date: date)
        case .createAction:
            router.input(.presentdCreateAction(goalID: goal?.id!))
        case .calendarHeader(let headerType):
            showHeaderCalendar(headerType)
        case .yearMonthAlert(date: let date):
            let vc = YearMonthAlertViewController.createController(currentDate: date) { [weak self] (selectDate) in
                self?.currentDate = selectDate
                self?.checkedMonthWhenNewMonth(date: selectDate)
            }
            router.input(.yearMonthAlert(vc))
        case .subscribeToUpdate:
            subscribeToUpdate()
            
        case .goalItem(goal: let goal):
            
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
                    
//                    ss.goalToUnlock = goal
//                    ss.unlockGoal()
//                    return
                    
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
                        print("We don't have such product: Stake\(stake)")
                    }
                    LevelOfMasteryService.shared.input(.unlockGoal(goalID: goal.id!))
                }))
            } else {
                let calendarVC = StoryboardScene.Act.calendarActionsListViewController.instantiate()
                calendarVC.presenter.goal = goal
                router.input(.goalItem(calendarVC: calendarVC))
            }
            
        case .longTapAction(event: let event):
            longTapAction(event: event)
            
        case .longTapGoal(goal: let goal):
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
            
        case .selectEvent(indexPath: let indexPath):
            selectEvent(indexPath: indexPath)
            
        case .tapPlus:
            router.input(.tapPlus)
        case .createGoal:
            router.input(.createGoal)
        }
    }
    
    
    
    private func longTapAction(event: Event) {
        
        if type == BaseStakesDataSourceType.archive {
            return
        }
        
        if let content = event.action?.content {
            AlertViewService.shared.input(.startActionForContent(content: content, tapStartNow: { [weak self] in
//                print("Start content - \(content)")
                
                guard let activityContent = ActivityContent.map(content: content) else {return}
                
                self?.selectedContent = activityContent
                
                switch activityContent.type {
                case .meditation, .hypnosis, .peptalk:
                    PlayerViewController.createController(content: activityContent)
                case .lesson, .story:
                    let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
                    vc.viewModel = DescriptionViewModel.map(activityContent: activityContent)
                    vc.isDownloadedContent = DataSource.shared.contains(content: activityContent)
                    self?.viewController?.navigationController?.present(vc, animated: true, completion: nil)
                default:
                    break
                }
                
                
//                AudioService.shared.tracks = activityContent.audioTracks
//                AudioService.shared.image = .path(activityContent.imageURL)
//                AudioService.shared.startPlayer(isPlaying: activityContent.type != .meditation,
//                                                isDownloadedContent: DataSource.shared.contains(content: activityContent),
//                                                content: activityContent)
//                AudioService.shared.playerDelegate = self?.viewController
                
            }))
        }
    }
    
    private func selectEvent(indexPath: IndexPath){
        
        if type == BaseStakesDataSourceType.archive {
            return
        }
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        
        if case .event(viewModel: let viewModelStake) = item {
            
            if StatusType.completeUpdate.rawValue < viewModelStake.event.status { return }
            
            let points = viewModelStake.event.calculatePoints
            
            AlertViewService.shared.input(.editAction(actionID: viewModelStake.event.action?.id, eventID: viewModelStake.event.id, points: points, tapAddPlan: {
                //self.tapDoneEvent(eventID: viewModelStake.event.id!)
            }, tapDelete: {
                //self.deleteAction(actionID: viewModelStake.event.action!.id!)
            }))
        }
    }
    
    private func createDataSource(goalID: String?) {
        
        baseDataSource.removeAll()
        calendarDataSource.removeAll()
        currentDate = Date()
        rangeDate = RangeDatePeriod.initRange(date: type.startDatePeriod())
        self.goalID = goalID
        interactor.input(.createDataSource(type: type, goalID: goalID, startDate: rangeDate.start, endDate:rangeDate.end, success: { [weak self] dataSections in
            self?.baseDataSource += dataSections
            self?.configDataSource(date: nil)
        }))
    }
    
    private func uploadNewEventInDataSourceWhenScroll(count: Int) {
        if isNoMoreDownloadContent == false, isLoadContent == false, count >= dataSource.count - 10, dataSource.isEmpty == false, isCalendarVisible == false {
            isLoadContent = true
            self.rangeDate = rangeDate.addOneMonthToRange()
            
            switch type {
            case .forGoal:
                if self.rangeDate.checkEndDates(endGoalDate: goal?.endDate as Date?) {
                    return
                }
            default:
                if self.rangeDate.checkEndDates(endGoalDate: type.endDatePeriod()) {
                    return
                }
            }
            
            interactor.input(.createDataSource(type: type, goalID: goalID, startDate: rangeDate.start, endDate:rangeDate.end, success: { [weak self] dataSections in
                self?.baseDataSource += dataSections
                self?.configDataSource(date: nil)
            }))
        }
    }
    
    private func configDataSource(date: Date?) {
        
        dataSource.removeAll()
        
        if isCalendarVisible == true {
            
            calendarSection.items.removeAll()
            calendarSection.items.append(.calendar(dates: calendarDataSource))
            if let newDate = date {
                
                let search = baseDataSource.filter { (sectionModel) -> Bool in
                    
                    if case .calendar(viewModel: let viewModel) = sectionModel.section {
                        return viewModel.date.dayOfMonthOfYear() == newDate.dayOfMonthOfYear()
                    }
                    return false
                }
                dataSource = [calendarSection]
                dataSource += search
            }else {
                dataSource = [calendarSection]
            }
        }else {
            if goalSection != nil {
                dataSource = [goalSection]
            }
            dataSource += baseDataSource
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.tableView.backgroundView = (self?.dataSource.isEmpty ?? false) ? EmptyActView.loadFromNib() : UIView()
            self?.viewController?.tableView.reloadData()
            self?.isLoadContent = false
            
            self?.viewController?.checkNeedInfo()
        }
    }
    
    private func checkingMonthWhenScroll(date: Date) {
        checkedMonthWhenNewMonth(date: date, isNewRequestDataSource: false)
    }
    
    private func checkedMonthWhenNewMonth(date: Date, isNewRequestDataSource: Bool = true) {
        let search = baseDataSource.filter { (sectionModel) -> Bool in
            
            if case .calendar(viewModel: let viewModel) = sectionModel.section {
                return viewModel.date.monthOfYear() == date.monthOfYear()
            }
            
            return false
        }
        if search.isEmpty {
            self.rangeDate = RangeDatePeriod.initRange(date: date)
            interactor.input(.createDataSource(type: type, goalID: goalID, startDate: rangeDate.start, endDate:rangeDate.end, success: { [weak self] dataSections in
                self?.baseDataSource += dataSections
                self?.configDataSource(date: nil)
            }))
        }else if isNewRequestDataSource {
            configDataSource(date: date)
        }
    }
    
    private func showHeaderCalendar(_ headerType: ActHeaderType) {
        
        if headerType == .plus {
            input(.createAction)
            return
        }
        
        if headerType == .calendar {
            isCalendarVisible = true
            let firstElem = baseDataSource.first
            
            if case .calendar(viewModel: var section) = firstElem?.section {
                section.type = ActHeaderType.none
                section.rightButtonIsHidden = true
            }
            
            //            firstElem?.section.type = ActHeaderType.none
            //            firstElem?.section.rightButtonIsHidden = true
        } else if headerType == .list {
            isCalendarVisible = false
            let firstElem = baseDataSource.first
            
            if case .calendar(viewModel: var section) = firstElem?.section {
                section.type = ActHeaderType.calendar
                section.rightButtonIsHidden = false
            }
            
            //            firstElem?.section.type = ActHeaderType.calendar
            //            firstElem?.section.rightButtonIsHidden = false
            if let goalIDTemp = self.goal?.id {
                input(.createDataSource(goalID: goalIDTemp))
            }
        }
        configDataSource(date: nil)
    }
    
    private func subscribeToUpdate() {
        
        DataSource.shared.changeContext.subscribe(onNext: { (_) in
            self.input(.createDataSource(goalID: self.goal?.id))
        }).disposed(by: disposeBag)
    }
    
    func succesfullPayment() {
        //TODO: Unlock goal with goalToUnlock
        unlockGoal()
        router.showThankForPaymentController()
    }
    
    private func unlockGoal() {
        
        let coreData = DataSource.shared
        
        guard let goal = goalToUnlock, let goalId = goal.id else { return }
        
        goal.status = StatusType.wait.rawValue
        
        let events = DataSource.shared.eventOfGoal(goalID: goalId)
        
        for event in events {
            if event.status > 4 {
                coreData.updateEvent(eventID: event.id!) {
                    print("Event updated successfully!")
                }
                
                let actions = DataSource.shared.getActions(for: goal)
                
                for action in actions {
                    if action.status > 4 {
                        action.status = StatusType.wait.rawValue
                    }
                }
                
                if goal.status > 4 {
                    goal.status = StatusType.completed.rawValue
                }
                
            }
        }

        do {
            try DataSource.shared.viewContext.save()
        } catch {
            print("Can't save main context")
        }
        
        DataSource.shared.saveBackgroundContext()
        
    }
    
}
