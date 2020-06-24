//
//  HomeViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum HomeViewInput {
    case goalsUpdated
}

protocol HomeViewInputProtocol: class {
    func input(_ inputCase: HomeViewInput)
}

class HomeViewController: UIViewController, SideMenuItemContent, HomeViewInputProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapMenuButton(_ sender: UIBarButtonItem) {
        presenter.input(.menuShow)
    }
    
    var headerHomeView : HeaderHomeView!
    
    typealias Presenter = HomePresenter
    typealias Configurator = HomeConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = HomeConfigurator()
    
    private var actionItems: [ActivityViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        configurator.configure(with: self)
        
        presenter.input(.subscribeForUpdates)
        prepareDataSource()
        configureHeaderView()
//        let height = headerHomeView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        var frame = headerHomeView.frame
//        frame.size.height = height
//        headerHomeView.frame = frame
//        tableView.tableHeaderView = headerHomeView
        
        registerXibs()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = ColorName.primaryBlue.color
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureHeaderView() {
        headerHomeView = HeaderHomeView()
        headerHomeView.delegate = self
        headerHomeView.contentView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: headerHomeView.contentView.bounds.size.width)
    }
    
    func registerXibs() {
        tableView.registerNib(UnlockPremiumTableViewCell.self)
        tableView.registerNib(ActivityCollectionTableViewCell.self)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(profileChanged(_:)),
                                               name: .profileChanged,
                                               object: nil)
    }
    
    private func prepareDataSource() {
        presenter.input(.prepareDataSource({ [weak self] actionItems in
            self?.actionItems = actionItems
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = headerHomeView else {
            return
        }
        
        // The table view header is created with the frame size set in
        // the Storyboard. Calculate the new size and reset the header
        // view to trigger the layout.
        // Calculate the minimum height of the header view that allows
        // the text label to fit its preferred width.
        let size = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if headerView.contentView.frame.size.height != size.height {
            headerView.contentView.frame.size.height = size.height
            
            // Need to set the header view property of the table view
            // to trigger the new layout. Be careful to only do this
            // once when the height changes or we get stuck in a layout loop.
            tableView.tableHeaderView = headerView.contentView
            
            // Now that the table view header is sized correctly have
            // the table view redo its layout so that the cells are
            // correcly positioned for the new header size.
            // This only seems to be necessary on iOS 9.
            tableView.layoutIfNeeded()
        }
        
        setupTableViewBackground()
    }
    
    private func setupTableViewBackground() {
        let backgroundView = UIView(frame: tableView.bounds)
        
        let additionalBlueView = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: tableView.frame.width,
                                                      height: tableView.frame.height / 2))
        additionalBlueView.backgroundColor = ColorName.primaryBlue.color
        
        let bottomWhiteView = UIView(frame: CGRect(x: 0,
                                                   y: backgroundView.frame.height / 2,
                                                   width: tableView.frame.width,
                                                   height: tableView.frame.height / 2))
        
        backgroundView.addSubview(additionalBlueView)
        backgroundView.addSubview(bottomWhiteView)
        
        tableView.backgroundView = backgroundView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerHomeView.setBoldness(boldness: SettingsService.shared.boldness)
    }
    
    func input(_ inputCase: HomeViewInput) {
        switch inputCase {
        case .goalsUpdated:
            prepareDataSource()
        }
    }
    
    @objc private func profileChanged(_ notification: Notification) {
        headerHomeView.configureTitle()
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = actionItems[indexPath.row]
        switch item.type {
        case .feel, .think, .actActive, .actNotActive, .activeGoals, .activeGoalsAct:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
            cell.configCell(viewModel: item)
            cell.cellBackground(indexPath: indexPath)
            cell.delegate = self
            return cell
        case .boldManifest, .unlockPremium :
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as UnlockPremiumTableViewCell
            cell.configCell(type: item.type)
            cell.delegate = self
            cell.cellBackground(indexPath: indexPath)
            return cell
        default:
            return UITableViewCell.init()
        }
    }
}


// MARK:- UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actionItems[indexPath.row].type.rowHeight()
    }
}


//MARK:- ActivityCollectionTableViewCellDelegate

extension HomeViewController: ActivityCollectionTableViewCellDelegate {
    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath) {
        guard let cellIndexPath = tableView.indexPath(for: activityCollectionTableViewCell) else { return }
        let item = actionItems[cellIndexPath.row]
        presenter.input(.actionItem(item, indexPath.row))
    }
    
    func tapItemCollection(goal: Goal) {
        presenter.input(.goalItem(goal))
    }
    
    func tapShowAllActivity(type: HomeActionsTypeCell?) {
        guard let type = type else { return }
        presenter.input(.actionAll(type))
    }
    
    func tapEmptyGoalsCell(type: ActivityViewModel?) {
        presenter.input(.createGoal)
    }
    
    func longTap(goal: Goal) {
        presenter.input(.editGoal(goal))
    }
}


// MARK:- UnlockPremiumTableViewCellDelegate

extension HomeViewController: UnlockPremiumTableViewCellDelegate {
    
    func tapBoldManifest() {
        presenter.input(.showBoldManifest)
    }
    
    func tapUnlockPremium() {
        presenter.input(.unlockBoldManifest)
    }
}

extension HomeViewController: HeaderHomeViewDelegate {
    
    func tapShowLevel() {
        presenter.input(.showLevelOfMastery)
    }
    
}
