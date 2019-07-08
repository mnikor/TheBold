//
//  AddActionPlanViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum AddActionCellType {
    case headerAddToPlan
    case headerEditAction
    case duration
    case reminder
    case goal
    case stake
    case share
    
    func iconType() -> UIImage? {
        switch self {
        case .duration:
            return Asset.addActionDuration.image
        case .reminder:
            return Asset.addActionReminder.image
        case .goal:
            return Asset.addActionGoal.image
        case .stake:
            return Asset.addActionStake.image
        case .share:
            return Asset.addActionShare.image
        default :
            return nil
        }
    }
    
    func textType() -> String? {
        switch self {
        case .duration:
            return L10n.Act.duration
        case .reminder:
            return L10n.Act.reminder
        case .goal:
            return L10n.Act.goal
        case .stake:
            return L10n.Act.stake
        case .share:
            return L10n.Act.shareWithFriends
        default :
            return nil
        }
    }
    
    func hideValue() -> Bool {
        switch self {
        case .share:
            return true
        default:
            return false
        }
    }
}

class AddActionPlanViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var addActionView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addActionButton: RoundedButton!
    
    @IBOutlet weak var bottomAddActionConstraint: NSLayoutConstraint!
    
    @IBAction func tapAddActionButton(_ sender: UIButton) {
        hideAnimateView()
    }
    
    lazy var listSettings : [AddActionEntity] = {
        return [
                AddActionEntity(type: .duration, currentValue: "Thu, 1 Feb, 2019"),
                AddActionEntity(type: .reminder, currentValue: "Off"),
                AddActionEntity(type: .goal, currentValue: "Marathon"),
                AddActionEntity(type: .stake, currentValue: "No stake"),
                AddActionEntity(type: .share, currentValue: nil)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addActionView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        overlayView.alpha = 0
        bottomAddActionConstraint.constant = -self.addActionView.bounds.height
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 156
        tableView.tableFooterView = UIView()
        registerXibs()
        
        addHeader()
        addSwipe()
        
    }
    
    func addHeader() {
        listSettings.insert(AddActionEntity(type: .headerAddToPlan, currentValue: nil), at: 0)
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
        addActionView.addGestureRecognizer(swipe)
    }

    @objc func actionSwipe() {
        hideAnimateView()
    }
    
    func registerXibs() {
        tableView.registerNib(HeaderActionPlanTableViewCell.self)
        tableView.registerNib(HeaderTitleActionPlanTableViewCell.self)
        tableView.registerNib(SettingActionPlanTableViewCell.self)
    }

    func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.bottomAddActionConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0
            self.bottomAddActionConstraint.constant = -self.addActionView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
}

extension AddActionPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch listSettings[indexPath.row].type {
        case .headerAddToPlan:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderActionPlanTableViewCell
            return cell
        case .headerEditAction:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderTitleActionPlanTableViewCell
            return cell
        case .duration, .reminder, .goal, .stake, .share :
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as SettingActionPlanTableViewCell
            cell.config(item: listSettings[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

struct AddActionEntity {
    var type: AddActionCellType
    var currentValue : Any?
}

