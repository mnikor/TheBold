//
//  SettingsViewController.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, SideMenuItemContent, ViewProtocol {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var highNavigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewProtocol
    
    typealias Presenter = SettingsPresenter
    typealias Configurator = SettingsConfigurator
    
    var presenter : Presenter!
    var configurator : Configurator! = SettingsConfigurator()
    
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        navigationController?.navigationBar.isHidden = true
        highNavigationBar.configItem(title: L10n.Settings.settings, titleImage: .none, leftButton: .showMenu, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerNib(SettingsTableViewCell.self)
        presenter.input(.setupDataSource({ [weak self] in
            self?.tableView.reloadData()
        }))
    }
}

extension SettingsViewController: NavigationViewDelegate {
    
    //MARK: NavigationViewDelegate
    
    func tapLeftButton() {
        presenter.input(.showMenu)
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: SettingsModel = presenter.tableViewDataSource[indexPath.section].items[indexPath.row]
        
        switch model.cellType {
        case .privacy, .terms, .premium:
            presenter.input(.present(model.cellType))
        case .googleCalendar, .iCloud, .iosCalendar, .onWifi, .version:
            //do nothing
            break
        case .signOut:
            presenter.input(.signOut)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: .zero)
        headerView.backgroundColor = .clear
        
        guard let headerTitle: String = presenter.tableViewDataSource[section].header else {
            return headerView
        }
        
        //setup header label
        let headerLabel = UILabel(frame: .zero)
        
        headerLabel.font = UIFont(font: FontFamily.MontserratMedium.regular, size: 15)
        headerLabel.textColor = UIColor.hexStringToUIColor(hex: "767E96")
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        
        headerLabel.text = headerTitle
        
        if headerTitle == "Synchronize" {
            /// Add additional label
            let inDevLabel = UILabel()
            inDevLabel.translatesAutoresizingMaskIntoConstraints = false
            inDevLabel.font = UIFont(font: FontFamily.MontserratMedium.regular, size: 15)
            inDevLabel.text = "In development and will be available in next versions"
            inDevLabel.numberOfLines = 0
            inDevLabel.textColor = UIColor.hexStringToUIColor(hex: "767E96")
            
            headerView.addSubview(inDevLabel)
            
            NSLayoutConstraint.activate([
                inDevLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
                inDevLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
                inDevLabel.widthAnchor.constraint(equalToConstant: 220)
            ])
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == presenter.tableViewDataSource.firstIndex(where: { (sectionModel) -> Bool in
            return sectionModel.header == L10n.Settings.support
        }) {
            //remove footer from the support section
            return 0
        }
        return 35
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableViewDataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingsTableViewCell
        cell.setupCell(model: presenter.tableViewDataSource[indexPath.section].items[indexPath.row]) { [weak self] (aBool, cellType) in
            self?.presenter.input(.putInitialValue(cellType, aBool))
        }
        return cell
    }
}
