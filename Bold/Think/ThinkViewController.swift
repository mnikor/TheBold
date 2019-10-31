//
//  ThinkViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ThinkViewController: FeelViewController {

    override var contentTypes: [ContentType] {
        return [.story, .quote, .lesson]
    }
    
//    override var feelItems: [FeelEntity] {
//        get {return thinkItems}
//        set {thinkItems = newValue}
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let item = items[indexPath.row]
        switch item.type {
        case .stories, .lessons:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionCollectionTableViewCell
            cell.delegate = self
            cell.config(entity: item)
            cell.cellBackground(indexPath: indexPath)
            return cell
        case .citate:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as CitationTableViewCell
            cell.delegate = self
            if let quote = item.items.first {
                cell.config(authorName: quote.authorName, body: quote.body)
            }
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
