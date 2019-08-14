//
//  ThinkViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ThinkViewController: FeelViewController {

    private lazy var thinkItems : [FeelEntity] = {
        return [FeelEntity(type: .stories, items: [1, 2, 3 ,4]),
                FeelEntity(type: .citate, items: []),
                FeelEntity(type: .lessons, items: [1, 2, 3, 4, 5])]
        
    }()
    
//    override var feelItems: [FeelEntity] {
//        get {return thinkItems}
//        set {thinkItems = newValue}
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.feelItems = thinkItems
        
        navigationController?.navigationBar.isHidden = true
        highNavigationBar.configItem(title: L10n.Think.thinkBold, titleImage: .none, leftButton: .showMenu, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView()
        registerXibs()
    }
    
    override func registerXibs() {
        super.registerXibs()
        tableView.registerNib(CitationTableViewCell.self)
    }
    
//    override func showAll(typeCells: FeelTypeCell) {
//        performSegue(withIdentifier: StoryboardSegue.Think.showItem.rawValue, sender: typeCells)
//    }
    
}

extension ThinkViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch thinkItems[indexPath.row].type {
        case .stories, .lessons:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionCollectionTableViewCell
            cell.delegate = self
            cell.config(entity: presenter.feelItems[indexPath.row])
            cell.cellBackground(indexPath: indexPath)
            return cell
        case .citate:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as CitationTableViewCell
            cell.delegate = self
            //cell.config()
            cell.cellBackground(indexPath: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ThinkViewController: CitationTableViewCellDelegate {
    func tapMoreInfoButton() {
        performSegue(withIdentifier: StoryboardSegue.Think.citationIdentifier.rawValue, sender: nil)
    }
}
