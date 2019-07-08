//
//  FeelViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class FeelViewController: UIViewController, SideMenuItemContent {

    @IBOutlet weak var highNavigationBar: NavigationBottomView!
    @IBOutlet weak var progressView: ProgressHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var feelItems : [FeelEntity] = {
        return [FeelEntity(type: .meditation, items: [1, 2, 3 ,4]),
                FeelEntity(type: .hypnosis, items: [1, 2, 3]),
                FeelEntity(type: .pepTalk, items: [1, 2, 3, 4, 5])]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        highNavigationBar.configItem(title: L10n.Feel.feelBold, titleImage: .none, leftButton: .showMenu, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView()
        registerXibs()
    }
    
    func registerXibs() {
        tableView.registerNib(ActionCollectionTableViewCell.self)
    }
}

extension FeelViewController: NavigationBottomViewDelegate {
    func tapLeftButton() {
        showSideMenu()
    }
}

extension FeelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feelItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionCollectionTableViewCell
        cell.delegate = self
        cell.config(entity: feelItems[indexPath.row])
        cell.cellBackground(indexPath: indexPath)
        return cell
    }
}

extension FeelViewController: ActionCollectionTableViewCellDelegate {
    
    func tapItemCollection() {
        print("Show item")
        performSegue(withIdentifier: StoryboardSegue.Feel.feelPlayerIdentifier.rawValue, sender: nil)
    }
    
    func tapShowAll(typeCells: FeelTypeCell)  {
        print("Show all")
        performSegue(withIdentifier: StoryboardSegue.Feel.showItem.rawValue, sender: typeCells)
    }

}

extension FeelViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Feel.showItem.rawValue {
            let vc = segue.destination as! ActionsListViewController
            guard let type = sender as? FeelTypeCell else {return}
            vc.typeVC = type
        }
    }
}

struct FeelEntity {
    var type : FeelTypeCell
    var items: Array<Any>
}
