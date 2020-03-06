//
//  BaseStakesListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class BaseStakesListViewController: UIViewController, ViewProtocol {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = BaseStakesListPresenter
    typealias Configurator = BaseStakesListConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = BaseStakesListConfigurator()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfiguration()
    }
    
    convenience init() {
        self.init()
        setupConfiguration()
    }
    
    func setupConfiguration() {
        configurator.configure(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.input(.createDataSource(goalID: presenter.goal?.id))
        presenter.input(.subscribeToUpdate)
        
        configTableView()
        configNavigationController()
        registerXibs()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 82/255, green: 109/255, blue: 209/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.backgroundView = presenter.dataSource.isEmpty ? EmptyActView.loadFromNib() : UIView()
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 84
    }
    
    private func configNavigationController() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = presenter.goal?.name ?? L10n.viewAll
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.plusTodayActions.image, style: .plain, target: self, action: #selector(tapCreateAction))
    }
    
    @objc func tapCreateAction() {
        presenter.input(.createAction)
    }
    
    private func registerXibs() {
        tableView.registerNib(ActivityCollectionTableViewCell.self)
        tableView.registerNib(StakeActionTableViewCell.self)
        tableView.registerNib(CalendarTableViewCell.self)
        tableView.registerHeaderFooterNib(StakeHeaderView.self)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let vc = segue.destination as? CreateActionViewController {
    //            //vc.delegate = self
    //            //guard let settingType = sender as? AddActionCellType else {return}
    //            //vc.settingsActionType = settingType
    //            vc.presenter.goal = presenter.goal
    //        }
    //    }
    
//MARK:- InfoFunctions
    
    func checkNeedInfo() {
        
        if case .archive = presenter.type {
            return
        }
        
        if let infoVC = UIApplication.shared.keyWindow?.rootViewController?.children.last, ((infoVC as? InfoService) != nil) {
            return
        }
        
        let user = DataSource.shared.readUser()
        
//        user.goalInfo = false
//        user.stakeInfo = false
//        user.stakeContentInfo = false
//        DataSource.shared.saveBackgroundContext()
//        return
        
        if user.stakeInfo && user.stakeContentInfo && user.goalInfo {
            return
        }
        
        let vesibleCells = checkVisibilityOf()
        
        for cell in vesibleCells {
            
            if !user.goalInfo, let activityCell = cell as? ActivityCollectionTableViewCell {
                
                let indexPaths = activityCell.collectionView.indexPathsForVisibleItems.sorted()
                if indexPaths.isEmpty {
                    break
                }
                
                if let cell = activityCell.collectionView.cellForItem(at: indexPaths.first!), let goalCell = cell as? GoalCollectionViewCell {
                    
                    InfoService.showInfo(type: .goalCell, baseView: goalCell.goalView) { [unowned self] in
                        user.goalInfo = true
                        DataSource.shared.saveBackgroundContext()
                        self.checkNeedInfo()
                    }
                }
                break
            }
            
            if let stakeCell = cell as? StakeActionTableViewCell {
                
                let indexPath = tableView.indexPath(for: stakeCell)!
                let section = presenter.dataSource[indexPath.section]
                let item = section.items[indexPath.row]

                if case .event(viewModel: let cellModel) = item {

                    if !user.stakeContentInfo, let _ = cellModel.event.action?.content {

                        InfoService.showInfo(type: .stakeContentCell, baseView: stakeCell.contentActionView) { [unowned self] in
                            user.stakeContentInfo = true
                            DataSource.shared.saveBackgroundContext()
                            self.checkNeedInfo()
                        }
                        break
                    }else if !user.stakeInfo {

                        InfoService.showInfo(type: .stakeCell, baseView: stakeCell.contentActionView) { [unowned self] in
                            user.stakeInfo = true
                            DataSource.shared.saveBackgroundContext()
                            self.checkNeedInfo()
                        }
                        break
                    }
                }
            }
        }
    }
    
    func checkVisibilityOf() -> [UITableViewCell] { //(in aScrollView: UIScrollView?) {
        
        let cells = tableView.visibleCells
        
        if cells.isEmpty {
            return []
        }
        
        let filterCell = cells.filter { (cell) -> Bool in
            
            let indexPath = tableView.indexPath(for: cell)
            let cellRect = tableView.rectForRow(at: indexPath!)
            
            if tableView.bounds.contains(cellRect) {
                return true
            }else {
                return false
            }
        }
        return filterCell
    }
}


//MARK:- UIScrollViewDelegate

extension BaseStakesListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkNeedInfo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkNeedInfo()
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension BaseStakesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("dataSource.count \(presenter.dataSource.count)")
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionItem = presenter.dataSource[section]
        print("Section = \(section), items = \(sectionItem.items.count)")
        return sectionItem.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
        let section = presenter.dataSource[section]

        switch section.section {
        case .goal:
            return nil
        case .calendar(viewModel: let sectionModel):
            headerView.config(viewModel: sectionModel)
        case .stake(viewModel: let sectionModel):
            headerView.config(viewModel: sectionModel)
        }

        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            let headerModel = presenter.dataSource[section].section
            switch headerModel {
            case .goal:
                return 0
            default:
                return 84
            }
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.input(.uploadNewEventsInDataSourceWhenScroll(indexPath.section))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        switch item {
        case .calendar(dates: _):
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as CalendarTableViewCell
            cell.config(date: presenter.currentDate, startDate:presenter.goal?.startDate as Date?, endDate:presenter.goal?.endDate as Date?, modelView: item)
            cell.delegate = self
            return cell
        case .event(viewModel: _):
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as StakeActionTableViewCell
            cell.config(viewModel: item)
            cell.delegate = self
            return cell
        case .goals(viewModel: _):
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
            
            if case .goals(viewModel: let activityViewModel) = item {
                cell.configCell(viewModel: activityViewModel)
            }
            
            cell.delegate = self
            cell.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 249/255, alpha: 1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let section = presenter.dataSource[indexPath.section]
        
        if case .calendar(viewModel: let model) = section.section {
            switch model.type {
            case .goal:
                return
            default:
                presenter.input(.selectEvent(indexPath: indexPath))
            }
        }
    }
}


//MARK:- StakeHeaderViewDelegate

extension BaseStakesListViewController: StakeHeaderViewDelegate {

    func tapRightButton(type: ActHeaderType) {
        presenter.input(.calendarHeader(type))
    }
}


//MARK:- StakeActionTableViewCellDelegate

extension BaseStakesListViewController: StakeActionTableViewCellDelegate {
    
    func tapLongPress(event: Event) {
        presenter.input(.longTapAction(event: event))
    }
}


//MARK:- CalendarTableViewCellDelegate

extension BaseStakesListViewController: CalendarTableViewCellDelegate {
    
    func currentMonthInCalendar(date: Date) {
        print("CURRENT calendar month from = \(date)")
        presenter.input(.scrollToMonthInCalendar(date))
    }
    
    func tapMonthTitle(date: Date) {
        presenter.input(.yearMonthAlert(date: date))
    }
    
    func selectDate(date: Date) {
        print("\(date)")
        presenter.currentDate = date
        presenter.input(.selectCalendarSection(date: date))
        
    }
}

// MARK:- ActivityCollectionTableViewCellDelegate

extension BaseStakesListViewController: ActivityCollectionTableViewCellDelegate {
    func tapShowAllActivity(type: HomeActionsTypeCell?) {
        print("tapShowAllActivity")
        presenter.router.input(.allGoals)
    }

    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath) {
        print("tapItemCollection")
        //presenter.input(.goalItem)
    }
    
    func tapItemCollection(goal: Goal) {
        print("tapItemCollection")
        presenter.input(.goalItem(goal: goal))
    }
    
    func tapEmptyGoalsCell(type: ActivityViewModel?) {
        presenter.input(.createGoal)
    }
    
    func longTap(goal: Goal) {
        print("long Tap Goal = \(goal.id)")
        presenter.input(.longTapGoal(goal: goal))
    }
}
