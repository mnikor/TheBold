//
//  DownloadsActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ElementsAlertType {
    case header
    case addToPlan
    case delete
}

class DownloadsActionViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    
    var currentItem: DownloadsEntity!
    
    lazy var itemsAction: [DownloadsActionEntity] = {
        return [DownloadsActionEntity(type: .header, item: currentItem),
        DownloadsActionEntity(type: .addToPlan, item: nil),
        DownloadsActionEntity(type: .delete, item: nil)]
    }()
    
    var addActionPlan : (() -> Void)?
    var deleteItem : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        registerXibs()
        
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        overlayView.alpha = 0
        bottomContentViewConstraint.constant = -self.contentView.bounds.height
        addSwipe()
    }
    
    func registerXibs() {
        tableView.registerNib(DownloadTableViewCell.self)
        tableView.registerNib(SettingsDownloadTableViewCell.self)
    }
    
    class func createController(item: DownloadsEntity?, tapAddPlan: @escaping (() -> Void), tapDelete: @escaping (() -> Void)) -> DownloadsActionViewController {
        let addVC = StoryboardScene.AlertView.downloadsActionViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.currentItem = item
        addVC.addActionPlan = tapAddPlan
        addVC.deleteItem = tapDelete
        return addVC
    }
    
    func presentedBy(_ vc: UIViewController) {
        vc.present(self, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    func addSwipe() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSwipe))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        overlayView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        swipe.direction = .down
        contentView.addGestureRecognizer(swipe)
    }
    
    @objc func actionSwipe() {
        hideAnimateView()
    }
    
    func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.bottomContentViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0
            self.bottomContentViewConstraint.constant = -self.contentView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            //self.dismiss(animated: false, completion: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }

}


extension DownloadsActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsAction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let paramAction = itemsAction[indexPath.row]
        
        if paramAction.type == .header {
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as DownloadTableViewCell
            if let item = paramAction.item as? DownloadsEntity{
                cell.config(downloads:  item, action: true)
            }
            return cell
        }else {
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingsDownloadTableViewCell
            cell.config(type: paramAction.type)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("Index = \(indexPath.row)")
        let paramAction = itemsAction[indexPath.row]
        switch paramAction.type {
        case .header:
            return
        case .addToPlan:
            addActionPlan?()
        case .delete:
            deleteItem?()
        }
    }
    
}


struct DownloadsActionEntity {
    let type: ElementsAlertType
    let item: Any?
}
