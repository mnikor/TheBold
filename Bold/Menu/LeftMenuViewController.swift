//
//  MenuViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class LeftMenuViewController: MenuViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBottomView: MenuBottomView!
    
    var menuItems = [MenuItemType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        menuItems = [.home, .feel, .think, .act, .settings]
        menuBottomView.delegate = self
        configureBottomView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.99)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(profileChanged(_:)),
                                               name: .profileChanged,
                                               object: nil)
    }
    
    private func configureBottomView() {
        menuBottomView.setName(SessionManager.shared.profile?.firstName)
        menuBottomView.setUserImage(imagePath: SessionManager.shared.profile?.imageURL)
    }
    
    @objc private func profileChanged(_ notification: Notification) {
        configureBottomView()
    }
    
}

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        cell.config(typeCell: menuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select = \(menuItems[indexPath.row])")
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        menuContainerViewController.hideSideMenu()
    }
}

extension LeftMenuViewController: MenuBottomViewDelegate {
    func tapShowUsetProfile() {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[5])
        menuContainerViewController.hideSideMenu()
    }
    
    func tapShowLogIn() {
        // TODO
    }
    
}
