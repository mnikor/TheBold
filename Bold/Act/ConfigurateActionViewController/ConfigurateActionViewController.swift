//
//  ConfigurateActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ConfigurateActionViewControllerDelegate: class {
    func updateConfiguration()
}

class ConfigurateActionViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ConfigurateActionPresenter
    typealias Configurator = ConfigurateActionConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = ConfigurateActionConfigurator()

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ConfigurateActionViewControllerDelegate?
    
    var settingsActionType: AddActionCellType!
    var actionID : String!

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        configureTableView()
        registerXibs()
        configNavigationController()
        
        configureDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateConfiguration()
    }

    func createGoal() {
        
//        headers = [
//        ConfigureActionModel(headerType: ConfigureActionType.header(.chooseGoal),
//                                        bodysType: [ConfigureActionType.body(.goalName)]),
//                   
//                   ConfigureActionModel(headerType: ConfigureActionType.header(.orCreateNew),
//                                        bodysType: [ConfigureActionType.body(.enterGoal)])]
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        tableView.tableFooterView = footerView
    }
    
    func registerXibs() {
        tableView.registerNib(HeaderConfigureTableViewCell.self)
        tableView.registerNib(BodyConfigureTableViewCell.self)
        tableView.registerNib(DaysOfWeekTableViewCell.self)
        tableView.registerNib(EnterYourGoalTableViewCell.self)
    }
    
    func configNavigationController() {
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationItem.title = settingsActionType.textType()
    }
    
    func configureDataSource() {
        guard let settingsActionType = settingsActionType else { return }
        presenter.input(.searchAction(settingsActionType, actionID))
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource

extension ConfigurateActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.dataSource[section]
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = presenter.dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item.type {
        case .header(_):
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderConfigureTableViewCell
            cell.config(modelView: item.modelValue)
            return cell
        case .body(let bodyType):
            if bodyType == .enterGoal {
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as EnterYourGoalTableViewCell
                cell.config(modelView: item.modelValue)
                return cell
            }else if bodyType == .week {
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as DaysOfWeekTableViewCell
                cell.config(modelView: item.modelValue)
                cell.delegate = self
                return cell
            }else {
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as BodyConfigureTableViewCell
                cell.config(type: bodyType, modelView: item.modelValue)
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let section = presenter.dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item.type {
        case .header(_):
            return
        case .body(let bodyType):
            presenter.input(.selectBodyType(bodyType, indexPath.row))
        }
        tableView.reloadData()
    }
}

//MARK:- DaysOfWeekTableViewCellDelegate

extension ConfigurateActionViewController: DaysOfWeekTableViewCellDelegate {
    
    func selectDay(selectDays: [DaysOfWeekType]) {
        presenter.input(.selectDaysRepeat(selectDays))
    }
}
