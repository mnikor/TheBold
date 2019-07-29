//
//  ConfigurateActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ConfigurateActionViewControllerDelegate: class {
    func updateData()
}

class ConfigurateActionViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ConfigurateActionPresenter
    typealias Configurator = ConfigurateActionConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = ConfigurateActionConfigurator()

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ConfigurateActionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        viewHeader.backgroundColor = ColorName.tableViewBackground.color
        tableView.tableHeaderView = viewHeader
        registerXibs()
        configNavigationController()
    }
    
    func registerXibs() {
        //tableView.registerNib(HeaderWriteActionsTableViewCell.self)
        //tableView.registerNib(SettingActionPlanTableViewCell.self)
    }
    
    func configNavigationController() {
        
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationItem.title = "Duration"
    }

}

extension ConfigurateActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let settings = presenter.listSettings[indexPath.section]
//
//        switch settings[indexPath.row].type {
//        case .headerWriteActivity:
//            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderWriteActionsTableViewCell
//            cell.config()
//            return cell
//        case .duration, .reminder, .goal, .stake, .share :
//            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingActionPlanTableViewCell
//            cell.config(item: settings[indexPath.row])
//            return cell
//        default:
            return UITableViewCell()
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
//        let settings = presenter.listSettings[indexPath.section]
//        
//        switch settings[indexPath.row].type {
//        case .duration, .reminder, .goal, .stake, .share :
//            print("dsf")
//        default:
//            return
//        }
    }
    
}
