//
//  ThinkViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ThinkViewController: FeelViewController {

    private var playAnimationCallback : Callback<Bool>?
    
    override var contentTypes: [ContentType] {
        return [.story, .quote, .lesson]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimationCallback?(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playAnimationCallback?(false)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        highNavigationBar.configItem(title: L10n.Think.thinkBold, titleImage: .none, leftButton: .showMenu, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView()
        registerXibs()
        
        hideTitleInHighNavigationBar()
    }
    
    @objc private func appMovedToActive() {
        playAnimationCallback?(true)
    }
    
    private func hideTitleInHighNavigationBar() {
        highNavigationBar.titleLabel.isHidden = true
        highNavigationBar.infoButton.isHidden = true
    }
    
    override func registerXibs() {
        super.registerXibs()
        tableView.registerNib(CitationTableViewCell.self)
        tableView.registerNib(NavigationTitleAndProgressTableViewCell.self)
    }
}

extension ThinkViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = tableView.dequeReusableCell(indexPath: indexPath) as NavigationTitleAndProgressTableViewCell
            headerCell.titleLabel.text = L10n.Think.thinkBold
            return headerCell
        } else {
            let item = items[indexPath.row - 1]
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
                    cell.config(content: quote)
                }
                cell.cellBackground(indexPath: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}

extension ThinkViewController: CitationTableViewCellDelegate {
    func tapMoreInfoButton() {
        performSegue(withIdentifier: StoryboardSegue.Think.citationIdentifier.rawValue, sender: nil)
    }
    
    func animateState(status: @escaping (Bool) -> Void) {
        playAnimationCallback = status
    }
}
