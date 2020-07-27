//
//  LevelOfMasteryViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class LevelOfMasteryViewController: UIViewController, ViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var footerView: LevelOfMasteryFooterView!
    
    typealias Presenter = LevelOfMasteryPresenter
    typealias Configurator = LevelOfMasteryConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    private var isPremium = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        configureNavigationBar()
        setupTableView()
        registerXibs()
        
        presenter.input(.createDataSource)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = prepareTitleView()
        let leftBarButtonItem = UIBarButtonItem(image: Asset.arrowBack.image,
                                                style: .plain, target: self, action: #selector(didTapAtBackBarButtonItem(_:)))
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4745098039, green: 0.5568627451, blue: 0.8509803922, alpha: 1)
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func prepareTitleView() -> UILabel {
        let label = UILabel()
        label.font = FontFamily.MontserratMedium.regular.font(size: 17)
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3607843137, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = L10n.Profile.levelOfMastery
        return label
    }
    
    @objc private func didTapAtBackBarButtonItem(_ sender: UIBarButtonItem) {
        presenter.input(.close)
    }
    
    private func setupTableView() {
        tableView.tableFooterView = footerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 122
    }
    
    private func registerXibs() {
        tableView.registerNib(LevelOfMasteryTableViewCell.self)
        tableView.registerNib(UnlockPremiumTableViewCell.self)
    }

}

extension LevelOfMasteryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Add check for premium
        isPremium = DataSource.shared.isPremiumUser()
        if isPremium {
            return presenter.levels.count
        } else {
            return presenter.levels.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && !isPremium {
            /// Add check for premium
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as UnlockPremiumTableViewCell
            cell.delegate = self
            return cell
        } else {
            /// Check for premium
            let index = isPremium ? indexPath.row : indexPath.row - 1
            let level = presenter.levels[index]
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as LevelOfMasteryTableViewCell
            cell.config(level: level)
            return cell
        }
    }
    
}

extension LevelOfMasteryViewController: UnlockPremiumTableViewCellDelegate {
    func tapBoldManifest() {
    }
    
    func tapUnlockPremium() {
        presenter.input(.unlockPremium)
    }
    
}
