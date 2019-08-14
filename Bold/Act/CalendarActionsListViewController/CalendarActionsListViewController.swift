//
//  CalendarActionsListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarActionsListViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = CalendarActionsListPresenter
    typealias Configurator = CalendarActionsListConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = CalendarActionsListConfigurator()
    
    var currentGoal: GoalEntity!
    //var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        tableView.backgroundView = presenter.actItems.isEmpty ? EmptyActView.loadFromNib() : UIView()
        tableView.tableFooterView = UIView()
        registerXibs()
        
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 84
        
        configNavigationController()
        registerXibs()
    }

    func configNavigationController() {
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Marathon"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.plusTodayActions.image, style: .plain, target: self, action: #selector(tapCreateAction))
    }
    
    @objc func tapCreateAction() {
        presenter.input(.createAction)
    }
    
    func registerXibs() {
        tableView.registerNib(ActivityCollectionTableViewCell.self)
        tableView.registerNib(StakeActionTableViewCell.self)
        tableView.registerNib(CalendarTableViewCell.self)
        tableView.registerHeaderFooterNib(StakeHeaderView.self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension CalendarActionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.actHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = presenter.actHeaders[section]
        return sectionItem.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
        let sectionItem = presenter.actHeaders[section]
        headerView.config(type: sectionItem.headerType)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionItem = presenter.actHeaders[indexPath.section]
        let act = sectionItem.items[indexPath.row]
        switch act.type {
        case .calendar:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as CalendarTableViewCell
            cell.config(date: presenter.currentDate)
            cell.delegate = self
            return cell
        case .stake:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as StakeActionTableViewCell
            cell.config()
            cell.delegate = self
            return cell
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        presenter.input(.editAction(presenter.actItems[indexPath.row]))
    }
    
}


//MARK:- StakeHeaderViewDelegate

extension CalendarActionsListViewController: StakeHeaderViewDelegate {
    
    func tapRightButton(type: ActHeaderType) {
        presenter.input(.calendarHeader(type))
    }
    
}


//MARK:- StakeActionTableViewCellDelegate

extension CalendarActionsListViewController: StakeActionTableViewCellDelegate {
    
    func tapLongPress() {
        presenter.input(.longTapAction)
    }
}


//MARK:- CalendarTableViewCellDelegate

extension CalendarActionsListViewController: CalendarTableViewCellDelegate {
    
    func tapMonthTitle(date: Date) {
        presenter.input(.yearMonthAlert)
    }
    
    func selectDate(date: Date) {
        presenter.currentDate = date
    }
}
