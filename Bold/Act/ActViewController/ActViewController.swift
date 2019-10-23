//
//  ActViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ActCellType {
    case goals
    case calendar
    case stake
}

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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.actItems.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
        headerView.config(type: .plus)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let act = presenter.actItems[indexPath.row]
        switch act.type {
        case .goals:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
            cell.configCell(entity: HomeEntity(type: .activeGoals, items: [1, 2, 3, 4]))
            cell.delegate = self
            cell.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 249/255, alpha: 1)
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
    }
}

// MARK:- ActivityCollectionTableViewCellDelegate

extension ActViewController: ActivityCollectionTableViewCellDelegate {
    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath) {
        print("tapItemCollection")
        presenter.input(.goalItem)
    }
    
    func tapShowAllActivity(type: FeelTypeCell) {
        print("tapShowAllActivity")
        presenter.input(.allGoals)
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
    func tapLongPress() {
        print("tapLongPress")
        presenter.input(.longTapAction)
    }
}
