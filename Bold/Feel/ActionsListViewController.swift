//
//  ActionsListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ActionCellType {
    case action
    case songOrListen
    
}

class ActionsListViewController: UIViewController {

    @IBOutlet weak var highNavigationBar: NavigationBottomView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerView: PlayerSmallView!
    
    var typeVC : FeelTypeCell = .meditation
    
    lazy var actions : [ActionEntity] = {
        return [ActionEntity(type: .action, header: .duration, download: true, like: true),
                ActionEntity(type: .action, header: .points, download: false, like: false),
                ActionEntity(type: .action, header: .unlock, download: false, like: false),
                ActionEntity(type: .songOrListen, header: nil, download: false, like: false),
                ActionEntity(type: .songOrListen, header: nil, download: false, like: false),
                ActionEntity(type: .songOrListen, header: nil, download: false, like: false),
                ActionEntity(type: .action, header: .unlock, download: false, like: false),
                ActionEntity(type: .action, header: .unlock, download: false, like: false),
                ActionEntity(type: .songOrListen, header: nil, download: false, like: false)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        highNavigationBar.configItem(title: typeVC.titleText()!, titleImage: .info, leftButton: .back, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
        registerXibs()
    }
    
    func registerXibs() {
        tableView.registerNib(ActionTableViewCell.self)
        tableView.registerNib(ListenOrReadTableViewCell.self)
    }
}


extension ActionsListViewController: NavigationBottomViewDelegate {
    
    func tapLeftButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension ActionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch actions[indexPath.row].type {
        case .action:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionTableViewCell
            cell.config(item: actions[indexPath.row])
            cell.delegate = self
            return cell
        case .songOrListen:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ListenOrReadTableViewCell
            //cell.config()
            return cell
        }
    }
    
}

extension ActionsListViewController: ActionTableViewCellDelegate {

    func tapLeftHeaderButton() {
        print("Unlock")
    }
    
    func tapThreeDotsButton(item: ActionEntity) {
        let text = "Share"
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        present(activityVC, animated: true, completion: nil)
    }
    
    func tapDownloadButton(cell: ActionTableViewCell) {
        print("download")
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = actions[indexPath.row]
        item.download = !item.download
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tapLikeButton(cell: ActionTableViewCell) {
        print("like")
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = actions[indexPath.row]
        item.like = !item.like
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tapAddActionPlanButton() {
        performSegue(withIdentifier: StoryboardSegue.Feel.feelActionsListToAddActionIdentifier.rawValue, sender: nil)
    }
}

class ActionEntity: NSObject {
    var type : ActionCellType
    var header : HeaderType?
    var download : Bool
    var like : Bool
    
    init(type: ActionCellType, header: HeaderType?, download: Bool, like: Bool) {
        self.type = type
        self.header = header
        self.download = download
        self.like = like
    }
    
    
}



