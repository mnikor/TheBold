//
//  ActViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ActViewController: BaseStakesListViewController, SideMenuItemContent {
    
    @IBOutlet weak var highNavigationBar: NavigationView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        LevelOfMasteryService.shared.input(.checkAllGoalsAndAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.presenter.type = BaseStakesDataSourceType.all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        highNavigationBar.configItem(title: L10n.Act.actBold, titleImage: .none, leftButton: .showMenu, rightButton: .callendar)
        highNavigationBar.deleagte = self

    }
}

// MARK:- UITableViewDelegate, NavigationViewDelegate

extension ActViewController: NavigationViewDelegate {
    
    func tapLeftButton() {
        showSideMenu()
    }
    
    func tapRightButton() {
        presenter.input(.calendarHeader(ActHeaderType.calendar))
    }
}
