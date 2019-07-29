//
//  CreateGoalViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = CreateGoalPresenter
    typealias Configurator = CreateGoalConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = CreateGoalConfigurator()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.tableFooterView = UIView()
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        viewHeader.backgroundColor = ColorName.tableViewBackground.color
        tableView.tableHeaderView = viewHeader
        registerXibs()
        configNavigationController()
    }
    
    func registerXibs() {
        tableView.registerNib(HeaderWriteActionsTableViewCell.self)
        tableView.registerNib(SettingActionPlanTableViewCell.self)
        tableView.registerNib(ColorCreateGoalTableViewCell.self)
        tableView.registerNib(ColorListCreateGoalTableViewCell.self)
        tableView.registerNib(IconListCreateGoalTableViewCell.self)
    }

    func configNavigationController() {
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = ColorName.primaryBlue.color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationItem.title = L10n.Act.Create.goalHeader
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.save, style: .plain, target: self, action: #selector(tapSaveAction))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: L10n.cancel, style: .plain, target: nil, action: nil)
    }
    
    @objc func tapSaveAction() {
        print("tapCreateAction")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


    // MARK: - UITableViewDelegate, UITableViewDataSource

extension CreateGoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.listSettings.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = ColorName.tableViewBackground.color
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let settings = presenter.listSettings[section]
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settings = presenter.listSettings[indexPath.section]
        let param = settings[indexPath.row]
        
        switch param.type {
        case .headerWriteActivity:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderWriteActionsTableViewCell
            cell.config(typeHeader: .goal)
            cell.delegate = self
            return cell
        case .starts, .ends, .icons:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingActionPlanTableViewCell
            cell.config(item: param)
            return cell
        case .color:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ColorCreateGoalTableViewCell
            cell.config(item: param, colorType: presenter.newGoal.color)
            return cell
        case .colorList:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ColorListCreateGoalTableViewCell
            cell.config(currentColor: presenter.newGoal.color)
            cell.delegate = self
            return cell
        case .iconsList:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as IconListCreateGoalTableViewCell
            cell.config(selectIcon: presenter.newGoal.icon, selectColor: presenter.newGoal.color)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let settings = presenter.listSettings[indexPath.section]
        
        switch settings[indexPath.row].type {
        case .headerWriteActivity:
            print("dsfdsf")
        case .starts:
            presenter.input(.showDateAlert(.startDate, Date()))
        case .ends:
            presenter.input(.showDateAlert(.endDate, Date()))
        case .colorList:
            print("dsfdsf")
        case .iconsList:
            print("dsfdsf")
        default:
            return
        }
    }
}


    //MARK:- HeaderWriteActionsTableViewCellDelegate

extension CreateGoalViewController: HeaderWriteActionsTableViewCellDelegate {
    
    func tapIdeas() {
        presenter.input(.ideas)
    }
}


    //MARK:- ColorListCreateGoalTableViewCellDelegate

extension CreateGoalViewController: ColorListCreateGoalTableViewCellDelegate {
    
    func tapSelectColor(colorType: ColorGoalType) {
        print("tap select color \(colorType)")
        presenter.input(.selectColor(colorType))
    }
}


    //MARK:- IconListCreateGoalTableViewCellDelegate

extension CreateGoalViewController: IconListCreateGoalTableViewCellDelegate {
    
    func tapSelectIcon(selectIcon: IdeasType) {
        print("tap select color \(selectIcon)")
        presenter.input(.selectIcon(selectIcon))
    }
}
