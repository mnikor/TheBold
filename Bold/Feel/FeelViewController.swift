//
//  FeelViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class FeelViewController: UIViewController, SideMenuItemContent {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var feelItems : [FeelEntity] = {
        return [FeelEntity(type: .meditation, items: [1, 2, 3 ,4]),
                FeelEntity(type: .hypnosis, items: [1, 2, 3]),
                FeelEntity(type: .pepTalk, items: [1, 2, 3, 4, 5])]
        
    }()
    
    @IBAction func tapMenuButton(_ sender: UIBarButtonItem) {
        showSideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "ActionCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionCollectionTableViewCell")
        
        //self.navigationItem.title = L10n.Feel.feelBold

//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//        } else {
//            // Fallback on earlier versions
//        }
    }
}


extension FeelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feelItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCollectionTableViewCell", for: indexPath) as! ActionCollectionTableViewCell
        cell.config(entity: feelItems[indexPath.row])
        cell.cellBackground(indexPath: indexPath)
        return cell
    }
    
    
}

struct FeelEntity {
    var type : FeelTypeCell
    var items: Array<Any>
}


//class HomeEntity: NSObject {
//
//    var type : HomeActionsTypeCell
//    var items : Array<Any>?
//
//    init(type: HomeActionsTypeCell, items: Array<Any>?) {
//        self.type = type
//        self.items = items
//    }
//
//}
