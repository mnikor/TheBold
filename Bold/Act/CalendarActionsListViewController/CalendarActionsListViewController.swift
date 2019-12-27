//
//  CalendarActionsListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarActionsListViewController: BaseStakesListViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.presenter.type = BaseStakesDataSourceType.forGoal
        
    }
    
}
