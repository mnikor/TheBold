//
//  HomeViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum HomeActionsTypeCell {
    case feel
    case think
    case boldManifest
    case actNotActive
    case actActive
    
    func rowHeight() -> CGFloat {
        switch self {
        case .feel, .think:
            return 310
        case .actActive:
            return 370
        case .actNotActive:
            return 260
        case .boldManifest:
            return 106
        }
    }
    
    func bottomCellHeight() -> CGFloat {
        switch self {
        case .feel, .think:
            return 34
        case .actActive:
            return 83
        case .actNotActive:
            return 51
        case .boldManifest:
            return 0
        }
    }
    
    func collectionCellSize() -> CGSize {
        switch self {
        case .feel, .think:
            return CGSize(width: 124, height: 172)
        case .actNotActive:
            return CGSize(width: 225, height: 102)
        case .actActive:
            return CGSize(width: 150, height: 181)
        case .boldManifest:
            return CGSize.zero
        }
    }
}

class HomeViewController: UIViewController, SideMenuItemContent, ViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func tapMenuButton(_ sender: UIBarButtonItem) {
        showSideMenu()
    }
    
    lazy var actionItems : [HomeEntity] = {
        return [HomeEntity(type: .feel, items: [1, 2, 3, 4]),
                HomeEntity(type: .boldManifest, items: nil),
                HomeEntity(type: .think, items: [1, 2, 3, 4]),
                HomeEntity(type: .actActive, items: [1, 2, 3, 4]),
                HomeEntity(type: .actNotActive, items: [1])]
    }()
    
    var headerHomeView : HeaderHomeView!
    
    typealias Presenter = HomePresenter
    typealias Configurator = HomeConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.view.addSubview(UIImageView(image: Asset.homeHeader2Bacground.image)) 
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        headerHomeView = HeaderHomeView()
//        let height = headerHomeView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        var frame = headerHomeView.frame
//        frame.size.height = height
//        headerHomeView.frame = frame
        tableView.tableHeaderView = headerHomeView
        
        registerXibs()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
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
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            
            // Need to set the header view property of the table view
            // to trigger the new layout. Be careful to only do this
            // once when the height changes or we get stuck in a layout loop.
            tableView.tableHeaderView = headerView
            
            // Now that the table view header is sized correctly have
            // the table view redo its layout so that the cells are
            // correcly positioned for the new header size.
            // This only seems to be necessary on iOS 9.
            tableView.layoutIfNeeded()
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch actionItems[indexPath.row].type {
        case .feel, .think, .actActive, .actNotActive:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
            cell.configCell(entity: actionItems[indexPath.row])
            cell.cellBackground(indexPath: indexPath)
            return cell
        case .boldManifest :
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as UnlockPremiumTableViewCell
            cell.delegate = self
            cell.cellBackground(indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actionItems[indexPath.row].type.rowHeight()
    }
}

extension HomeViewController: UnlockPremiumTableViewCellDelegate {
    func tapUnlockPremium() {
        print("Unlock premium")
        
        let vc = StoryboardScene.Home.manifestViewController.instantiate()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //performSegue(withIdentifier: "manifestIdentifier", sender: nil)
    }
}


extension UITableViewCell {
    
    func cellBackground(indexPath: IndexPath) {
        if indexPath.row%2 != 0 {
            self.backgroundColor = ColorName.cellEvenColor.color
        }else {
            self.backgroundColor = .white
        }
    }
}

class HomeEntity: NSObject {
    
    var type : HomeActionsTypeCell
    var items : Array<Any>?
    
    init(type: HomeActionsTypeCell, items: Array<Any>?) {
        self.type = type
        self.items = items
    }
    
}
