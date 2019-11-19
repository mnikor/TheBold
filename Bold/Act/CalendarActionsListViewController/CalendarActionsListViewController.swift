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

    func configTableView() {
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
        //tableView.registerNib(ActivityCollectionTableViewCell.self)
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

}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension CalendarActionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = presenter.dataSource[section]
        return sectionItem.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
        let section = presenter.dataSource[section]
        headerView.config(viewModel: section.section)
        headerView.delegate = self
        return headerView
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
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let section = presenter.dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        
        presenter.input(.editActionNew(item))
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
    
    func tapLongPress(event: Event) {
        
    }
}


//MARK:- CalendarTableViewCellDelegate

extension CalendarActionsListViewController: CalendarTableViewCellDelegate {
    
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
