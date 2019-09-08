//
//  CreateActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CreateActionViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = CreateActionPresenter
    typealias Configurator = CreateActionConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = CreateActionConfigurator()
    
    @IBOutlet weak var navBar: BlueNavigationBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        navigationController?.navigationBar.setBackgroundImage(Asset.navigationBlueImage.image, for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
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
    }

    func configNavigationController() {
        
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.shadowImage = UIImage()
        
        navBar.configure(type: .action, save: {
            print("Save")
        }) { [unowned self] in
            self.presenter.router.input(.cancel)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? ConfigurateActionViewController {
            vc.delegate = self
            guard let settingType = sender as? AddActionCellType else {return}
            vc.settingsActionType = settingType
        }
        if let vc = segue.destination as? StakeViewController {
            vc.delegate = self
            //vc.currentStake = 30
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
        
        switch settings[indexPath.row].type {
        case .headerWriteActivity:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderWriteActionsTableViewCell
            //cell.config(typeHeader: .action)
            return cell
        case .duration, .reminder, .goal, .stake, .share :
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingActionPlanTableViewCell
            //cell.config(item: settings[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let settings = presenter.listSettings[indexPath.section]
        
        switch settings[indexPath.row].type {
            case .duration, .reminder, .goal:
                presenter.input(.setting(settings[indexPath.row].type))
            case .stake:
                presenter.input(.stake)
            case .share:
                presenter.input(.share)
            default:
                return
        }
    }
    
}

extension CreateActionViewController: ConfigurateActionViewControllerDelegate {
    
    func updateData() {
        print("updateData")
    }
}

extension CreateActionViewController: StakeViewControllerDelegate {
    func confirmStake(stake: Float) {
        print("confirmStake \(stake)")
    }
}
