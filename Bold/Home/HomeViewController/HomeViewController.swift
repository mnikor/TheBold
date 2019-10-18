//
//  HomeViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {

    struct CellSize {
        static let feelAndThink = CGSize(width: 124, height: 172)
        static let actNotActive = CGSize(width: 225, height: 102)
        static let actActive = CGSize(width: 150, height: 181)
        static let activeGoals = CGSize(width: 160, height: 181)
        static let boldManifest = CGSize.zero
    }
    
    struct rowHeight {
        static let feelThinkActActiveActiveGoals:CGFloat = 310
        static let actNotActive:CGFloat = 260
        static let boldManifest:CGFloat = 106
    }
    
    struct bottomCellHeight {
        static let feelThinkActActiveActiveGoals:CGFloat = 30
        static let actNotActive:CGFloat = 51
        static let boldManifest:CGFloat = 0
    }
}

enum HomeActionsTypeCell {
    case feel
    case think
    case boldManifest
    case actNotActive
    case actActive
    case activeGoals
    
    func rowHeight() -> CGFloat {
        switch self {
        case .feel, .think, .actActive, .activeGoals:
            return Constants.rowHeight.feelThinkActActiveActiveGoals
        case .actNotActive:
            return Constants.rowHeight.actNotActive
        case .boldManifest:
            return Constants.rowHeight.boldManifest
        }
    }
    
    func bottomCellHeight() -> CGFloat {
        switch self {
        case .feel, .think, .actActive, .activeGoals:
            return Constants.bottomCellHeight.feelThinkActActiveActiveGoals
        case .actNotActive:
            return Constants.bottomCellHeight.actNotActive
        case .boldManifest:
            return Constants.bottomCellHeight.boldManifest
        }
    }
    
    func collectionCellSize() -> CGSize {
        switch self {
        case .feel, .think:
            return Constants.CellSize.feelAndThink
        case .actNotActive:
            return Constants.CellSize.actNotActive
        case .actActive:
            return Constants.CellSize.actActive
        case .activeGoals:
            return Constants.CellSize.activeGoals
        case .boldManifest:
            return Constants.CellSize.boldManifest
        }
    }
}

class HomeViewController: UIViewController, SideMenuItemContent, ViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapMenuButton(_ sender: UIBarButtonItem) {
        presenter.input(.menuShow)
    }
    
    var headerHomeView : HeaderHomeView!
    
    typealias Presenter = HomePresenter
    typealias Configurator = HomeConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = HomeConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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
    
    func configureHeaderView() {
        headerHomeView = HeaderHomeView()
        headerHomeView.contentView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: headerHomeView.contentView.bounds.size.width)
        headerHomeView.setName(SessionManager.shared.profile?.firstName)
    }
    
    func registerXibs() {
        tableView.registerNib(UnlockPremiumTableViewCell.self)
        tableView.registerNib(ActivityCollectionTableViewCell.self)
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
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.actionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.actionItems[indexPath.row].type {
        case .feel, .think, .actActive, .actNotActive, .activeGoals:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
            cell.configCell(entity: presenter.actionItems[indexPath.row])
            cell.cellBackground(indexPath: indexPath)
            cell.delegate = self
            return cell
        case .boldManifest :
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as UnlockPremiumTableViewCell
            cell.delegate = self
            cell.cellBackground(indexPath: indexPath)
            return cell
        }
    }
}


// MARK:- UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.actionItems[indexPath.row].type.rowHeight()
    }
}


//MARK:- ActivityCollectionTableViewCellDelegate

extension HomeViewController: ActivityCollectionTableViewCellDelegate {
    
    func tapShowAllActivity(type: FeelTypeCell) {
        presenter.input(.actionAll(type))
    }
    
    func tapItemCollection() {
        presenter.input(.actionItem)
    }
}


// MARK:- UnlockPremiumTableViewCellDelegate

extension HomeViewController: UnlockPremiumTableViewCellDelegate {
    
    func tapUnlockPremium() {
        presenter.input(.unlockBoldManifest)
    }
}

