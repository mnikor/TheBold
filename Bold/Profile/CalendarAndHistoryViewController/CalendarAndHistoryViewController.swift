//
//  CalendarAndHistoryViewController.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarAndHistoryViewController: BaseStakesListViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.presenter.type = BaseStakesDataSourceType.archive
        self.presenter.isCalendarVisible = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationController()
    }
    
    func configNavigationController() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4745098039, green: 0.5568627451, blue: 0.8509803922, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = prepareTitleView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.arrowBack.image, style: .plain, target: self, action: #selector(backBarButtonTapped(_:)))
    }
    
    private func prepareTitleView() -> UILabel {
        let label = UILabel()
        label.font = FontFamily.MontserratMedium.regular.font(size: 16.5)
        label.textColor = #colorLiteral(red: 0.08235294118, green: 0.09803921569, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = "Calendar & History"
        return label
    }
    
    
    // MARK: - Navigation
    
    @objc private func backBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
