//
//  CreateGoalViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {
    static let heightHeader : CGFloat = 40
    static let heightFooter : CGFloat = 11
    static let rowHeight : CGFloat = 56
}

enum CreateGoalViewInput {
    case updateState
}

protocol CreateGoalViewInputProtocol: ViewProtocol {
    func input(_ inputCase: CreateGoalViewInput)
}

class CreateGoalViewController: UIViewController, CreateGoalViewInputProtocol {
    
    typealias Presenter = CreateGoalPresenter
    typealias Configurator = CreateGoalConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = CreateGoalConfigurator()
    
    @IBOutlet weak var navBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBar: BlueNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    deinit {
        DataSource.shared.resetBackgroundContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        registerXibs()
        configNavigationController()
        
        
        if case .editGoalSheet(goalID: let goalID) = presenter.baseConfigType {
            presenter.input(.editGoal(goalID: goalID))
        }else {
            presenter.input(.createNewGoal)
        }
    }
    
    func registerXibs() {
        tableView.registerNib(HeaderWriteActionsTableViewCell.self)
        tableView.registerNib(SettingActionPlanTableViewCell.self)
        tableView.registerNib(ColorCreateGoalTableViewCell.self)
        tableView.registerNib(ColorListCreateGoalTableViewCell.self)
        tableView.registerNib(IconListCreateGoalTableViewCell.self)
        tableView.registerNib(HeaderTitleActionPlanTableViewCell.self)
    }

    func configNavigationController() {
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.shadowImage = UIImage()
        
        navBar.configure(type: .goal, save: { [weak self] in
            self?.presenter.input(.save)
        }) { [unowned self] in
            self.presenter.input(.cancel)
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
        navBar.isHidden = presenter.baseConfigType != .createNewGoalVC
        if presenter.baseConfigType == .createNewGoalVC {
            let headerAndFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: Constants.heightHeader))
            headerAndFooterView.backgroundColor = ColorName.tableViewBackground.color
            tableView.tableHeaderView = headerAndFooterView
            tableView.tableFooterView = headerAndFooterView
        }else {
            navBarTopConstraint.constant = -navBar.bounds.size.height
            tableView.backgroundColor = .white
            //tableView.isScrollEnabled = false
        }
    }
    
    func input(_ inputCase: CreateGoalViewInput) {
        switch inputCase {
        case .updateState:
            updateState()
        }
    }
    
    private func updateState() {
        tableView.reloadData()
        navBar.topItem?.rightBarButtonItem?.isEnabled = (presenter.modelView.nameGoal ?? "").count >= 3
    }
}


    // MARK: - UITableViewDelegate, UITableViewDataSource

extension CreateGoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = ColorName.tableViewBackground.color
        return presenter.baseConfigType == .createNewGoalVC ? viewFooter : nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return presenter.baseConfigType == .createNewGoalVC ? Constants.heightFooter : 0
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
        case .headerEditAction:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderTitleActionPlanTableViewCell
            cell.config(modelView: item)
            cell.delegate = self
            return cell
        case .starts, .ends, .icons:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingActionPlanTableViewCell
            cell.config(modelView: item)
            if presenter.baseConfigType != .createNewGoalVC {
                cell.isUserInteractionEnabled = presenter.isEditAction
            }
            return cell
        case .color:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ColorCreateGoalTableViewCell
            cell.config(modelView: item)
            return cell
        case .colorList:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ColorListCreateGoalTableViewCell
            cell.config(modelView: item)
            cell.delegate = self
            if presenter.baseConfigType != .createNewGoalVC {
                cell.isUserInteractionEnabled = presenter.isEditAction
            }
            return cell
        case .iconsList:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as IconListCreateGoalTableViewCell
            cell.config(modelView: item)
            cell.delegate = self
            if presenter.baseConfigType != .createNewGoalVC {
                cell.isUserInteractionEnabled = presenter.isEditAction
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.view.endEditing(true)
        let sectionDataSource = presenter.dataSource[indexPath.section]
        
        switch sectionDataSource.items[indexPath.row].type {
        case .starts:
            presenter.input(.showDateAlert(.startDate))
        case .ends:
            presenter.input(.showDateAlert(.endDate))
        default:
            return
        }
    }
}


    //MARK:- HeaderWriteActionsTableViewCellDelegate

extension CreateGoalViewController: HeaderWriteActionsTableViewCellDelegate {
    
    func editingName(name: String) {
        navBar.topItem?.rightBarButtonItem?.isEnabled = name.count >= 3
    }
    
    func tapIdeas() {
        presenter.input(.showIdeas)
    }
    
    func updateNameIdea(nameIdea: String) {
        presenter.input(.updateName(nameIdea))
    }
}


    //MARK:- ColorListCreateGoalTableViewCellDelegate

extension CreateGoalViewController: ColorListCreateGoalTableViewCellDelegate {
    
    func tapSelectColor(colorType: ColorGoalType) {
        presenter.input(.updateColor(colorType))
    }
}


    //MARK:- IconListCreateGoalTableViewCellDelegate

extension CreateGoalViewController: IconListCreateGoalTableViewCellDelegate {
    
    func tapSelectIcon(selectIcon: IdeasType) {
        presenter.input(.updateIcon(selectIcon))
    }
}


    //MARK:- IdeasViewControllerDeleagte

extension CreateGoalViewController:  IdeasViewControllerDeleagte {
    
    func selectIdea(selectIdea: IdeasType) {
        presenter.input(.updateIdeas(selectIdea))
    }
}


    // MARK: - HeaderTitleActionPlanTableViewCellDelegate

extension CreateGoalViewController: HeaderTitleActionPlanTableViewCellDelegate {
    
    func changeEditAction() {
        presenter.isEditAction = true
        presenter.input(.updateDataSource)
    }
    
    func updateNameAction(newName: String) {
        presenter.input(.updateName(newName))
    }
}
