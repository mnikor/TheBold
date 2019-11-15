//
//  ActViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ActViewController: UIViewController, SideMenuItemContent, ViewProtocol {
    
    typealias Presenter = ActPresenter
    typealias Configurator = ActConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = ActConfigurator()
    
    @IBOutlet weak var highNavigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        highNavigationBar.configItem(title: L10n.Act.actBold, titleImage: .none, leftButton: .showMenu, rightButton: .callendar)
        highNavigationBar.deleagte = self
        
        presenter.input(.createDataSource)
        presenter.input(.subscribeToUpdate)
        
        configTableView()
    }
    
    func configTableView() {
        tableView.tableFooterView = UIView()
        registerXibs()
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 84
    }
    
    func registerXibs() {
        tableView.registerNib(ActivityCollectionTableViewCell.self)
        tableView.registerNib(StakeActionTableViewCell.self)
        tableView.registerHeaderFooterNib(StakeHeaderView.self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CalendarActionsListViewController {
            guard let selectGoal = sender as? Goal else {
                return
            }
            vc.presenter.goal = selectGoal
        }
    }
}

// MARK:- UITableViewDelegate, NavigationViewDelegate

extension ActViewController: NavigationViewDelegate {
    
    func tapLeftButton() {
        presenter.input(.showMenu)
    }
    
    func tapRightButton() {
        presenter.input(.calendar)
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource

extension ActViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource[section].items.count
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        presenter.input(.uploadNewEventsInDataSourceWhenScroll(indexPath.section))
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
        let headerModel = presenter.dataSource[section].section
        
        switch headerModel {
        case .calendar(viewModel: let viewModel):
            headerView.config(viewModel: viewModel)
            headerView.delegate = self
        default:
            return nil
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerModel = presenter.dataSource[section].section
        switch headerModel {
        case .calendar(viewModel: _):
            return 84
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = presenter.dataSource[indexPath.section].items[indexPath.row]
        
        switch item.type {
        case .goals:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
            //cell.configCell(entity: HomeEntity(type: .activeGoals, items: [1, 2, 3, 4]))
            
            if case .goals(viewModel: let activityViewModel) = item.viewModel {
                cell.configCell(viewModel: activityViewModel)
            }
            
            cell.delegate = self
            cell.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 249/255, alpha: 1)
            return cell
        case .stake:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as StakeActionTableViewCell
            cell.config(viewModel: item.viewModel)
            cell.delegate = self
            return cell
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        presenter.input(.selectEvent(indexPath: indexPath))
    }
}

// MARK:- ActivityCollectionTableViewCellDelegate

extension ActViewController: ActivityCollectionTableViewCellDelegate {
    func tapShowAllActivity(type: HomeActionsTypeCell) {
        print("tapShowAllActivity")
        presenter.input(.allGoals)
    }

    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath) {
        print("tapItemCollection")
        //presenter.input(.goalItem)
    }
    
    func tapItemCollection(goal: Goal) {
        print("tapItemCollection")
        presenter.input(.goalItem(goal: goal))
    }
    
    func tapEmptyGoalsCell(type: ActivityViewModel) {
        presenter.input(.tapPlus)
    }
    
}

// MARK:- StakeHeaderViewDelegate

extension ActViewController: StakeHeaderViewDelegate {
    func tapRightButton(type: ActHeaderType) {
        print("tapPlusButton")
        presenter.input(.tapPlus)
    }
}

extension ActViewController: StakeActionTableViewCellDelegate {
    
    func tapLongPress(event: Event) {
        presenter.input(.longTapAction(event: event))
    }
}
