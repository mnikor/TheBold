//
//  CalendarAndHistoryViewController.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarAndHistoryViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = CalendarAndHistoryPresenter
    typealias Configurator = CalendarAndHistoryConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = CalendarAndHistoryConfigurator()
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configNavigationController()
        registerXibs()
    }
    
    func configNavigationController() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4745098039, green: 0.5568627451, blue: 0.8509803922, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = prepareTitleView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.arrowBack.image, style: .plain, target: self, action: #selector(backBarButtonTapped(_:)))
    }
    
    private func prepareTitleView() -> UILabel {
        let label = UILabel()
        label.font = FontFamily.MontserratMedium.regular.font(size: 16.5)
        label.textColor = #colorLiteral(red: 0.08235294118, green: 0.09803921569, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = "Calendar & History"
        return label
    }
    
    func registerXibs() {
        tableView.registerNib(ActivityCollectionTableViewCell.self)
        tableView.registerNib(StakeActionTableViewCell.self)
        tableView.registerNib(CalendarTableViewCell.self)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @objc private func backBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension CalendarAndHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.actHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = presenter.actHeaders[section]
        return sectionItem.items.count
    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard section > 0 else { return UIView() }
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
//        let sectionItem = presenter.actHeaders[section]
//        headerView.config(type: sectionItem.headerType)
////        headerView.delegate = self
//        return headerView
//    }
    
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

//MARK:- StakeActionTableViewCellDelegate

extension CalendarAndHistoryViewController: StakeActionTableViewCellDelegate {
    
    func tapLongPress() {
        presenter.input(.longTapAction)
    }
}


//MARK:- CalendarTableViewCellDelegate

extension CalendarAndHistoryViewController: CalendarTableViewCellDelegate {
    
    func tapMonthTitle(date: Date) {
        presenter.input(.yearMonthAlert)
    }
    
    func selectDate(date: Date) {
        presenter.currentDate = date
    }
}
