//
//  CreateActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {
    static let rowHeight : CGFloat = 56
    static let headerHeight : CGFloat = 40
    static let footerHeight : CGFloat = 11
}

protocol CreateActionViewControllerDelegate: class {
    func actionWasCreated()
}

class CreateActionViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = CreateActionPresenter
    typealias Configurator = CreateActionConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = CreateActionConfigurator()
    
    weak var delegate: CreateActionViewControllerDelegate?
    
    @IBOutlet weak var navBar: BlueNavigationBar!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerXibs()
        configNavigationController()
        configureTableView()
        
        presenter.input(.createNewAction)
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.tableFooterView = UIView()
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: Constants.headerHeight))
        viewHeader.backgroundColor = ColorName.tableViewBackground.color
        tableView.tableHeaderView = viewHeader
    }
    
    func registerXibs() {
        tableView.registerNib(HeaderWriteActionsTableViewCell.self)
        tableView.registerNib(SettingActionPlanTableViewCell.self)
    }

    func configNavigationController() {
        
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.shadowImage = UIImage()
        
        navBar.configure(type: .action, save: { [unowned self] in
            self.presenter.input(.save)
        }) { [unowned self] in
            self.presenter.input(.cancel)
        }
    }
    
    // MARK: - Segue Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ConfigurateActionViewController {
            vc.delegate = self
            guard let settingType = sender as? AddActionCellType else {return}
            vc.settingsActionType = settingType
            vc.actionID = presenter.newAction.id
            
//            guard let action = presenter.newAction else {return}
            
//            switch settingType {
//            case .when:
//                vc.modelViewType = ConfigureCellModelViewType.duration(startDate: action.startDate as Date? , endDate: action.endDate as Date?, repeatDay: action.repeatAction)
//            case .reminder:
//                vc.modelViewType = ConfigureCellModelViewType.reminders(reminder: action.reminder)
//            case .goal:
//                vc.modelViewType = ConfigureCellModelViewType.goals(goalID: action.goal?.id)
//            default:
//                return
//            }
        }
        
        if let vc = segue.destination as? StakeViewController {
            vc.delegate = self
            vc.currentStake = Float(presenter.newAction.stake)
        }
    }
}


// MARK: - UINavigationBarDelegate

extension CreateActionViewController: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CreateActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = ColorName.tableViewBackground.color
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.footerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDataSource = presenter.dataSource[section]
        return sectionDataSource.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionDataSource = presenter.dataSource[indexPath.section]
        let item = sectionDataSource.items[indexPath.row]
        
        switch item.type {
        case .headerWriteActivity:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderWriteActionsTableViewCell
            cell.config(modelView: item)
            cell.delegate = self
            return cell
        case .duration, .reminder, .goal, .stake, .share, .when :
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingActionPlanTableViewCell
            cell.config(modelView: item)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.view.endEditing(true)
        
        let sectionDataSource = presenter.dataSource[indexPath.section]
        let item = sectionDataSource.items[indexPath.row]
        
        switch item.type {
            case .duration, .reminder, .goal, .when:
                presenter.input(.setting(item.type))
            case .stake:
                presenter.input(.stake)
            case .share:
                presenter.input(.share)
            default:
                return
        }
    }
}


// MARK: - HeaderWriteActionsTableViewCellDelegate

extension CreateActionViewController: HeaderWriteActionsTableViewCellDelegate {
    
    func editingNameIdea(nameIdea: String) {
        presenter.input(.updateName(nameIdea))
    }
}

// MARK: - ConfigurateActionViewControllerDelegate

extension CreateActionViewController: ConfigurateActionViewControllerDelegate {
    
    func updateConfiguration() {
        presenter.input(.updateConfiguration)
    }
}


// MARK: - StakeViewControllerDelegate

extension CreateActionViewController: StakeViewControllerDelegate {
    
    func confirmStake(stake: Float) {
        presenter.input(.updateStake(stake))
    }
}
