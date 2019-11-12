//
//  LevelOfMasteryViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum LevelType: Int {
    case apprentice = 0
    case risingPower
    case intermidiate
    case seasoned
    case unstoppable
    
    static let types: [LevelType] = [apprentice, risingPower, intermidiate, seasoned, unstoppable]
    
    var iconImage : UIImage? {
        switch self {
        case .apprentice:
            return Asset.apprentice.image
        case .risingPower:
            return Asset.risingPower.image
        case .intermidiate:
            return Asset.intermediate.image
        case .seasoned:
            return Asset.seasoned.image
        case .unstoppable:
            return Asset.unstoppable.image
        }
    }
    
    var titleText : String? {
        switch self {
        case .apprentice:
            return L10n.Profile.LevelOfMastery.apprentice
        case .risingPower:
            return L10n.Profile.LevelOfMastery.risingPower
        case .intermidiate:
            return L10n.Profile.LevelOfMastery.intermidiate
        case .seasoned:
            return L10n.Profile.LevelOfMastery.seasoned
        case .unstoppable:
            return L10n.Profile.LevelOfMastery.unstoppable
        }
    }
    
    var limits: LimitsLevel {
        switch self {
        case .apprentice:
            return LimitsLevel(limitPoint: SimpleLevel(type: .points(500) , description: L10n.Profile.LevelOfMastery.points(500)),
                               limitsGoal: [])
        case .risingPower:
            return LimitsLevel(limitPoint: SimpleLevel(type: .points(300), description: L10n.Profile.LevelOfMastery.points(300)),
                               limitsGoal: [SimpleLevel(type: .goals(goalMid: 1, goalLong: 0), description: L10n.Profile.LevelOfMastery.RisingPower.midTermGoalAchieved)])
        case .intermidiate:
            return LimitsLevel(limitPoint: SimpleLevel(type: .points(600), description: L10n.Profile.LevelOfMastery.points(600)),
                               limitsGoal: [SimpleLevel(type: .goals(goalMid: 3, goalLong: 0), description: L10n.Profile.LevelOfMastery.Intermidiate.midTermGoals)])
        case .seasoned:
            return LimitsLevel(limitPoint: SimpleLevel(type: .points(1000), description: L10n.Profile.LevelOfMastery.Seasoned.minPoints(1000)),
                               limitsGoal: [
                                SimpleLevel(type: .goals(goalMid: 5, goalLong: 1), description: L10n.Profile.LevelOfMastery.Seasoned.longTermAndMidTermAchievedOrLongTermGoalsAchieved),
                                SimpleLevel(type: .goals(goalMid: 0, goalLong: 2), description: L10n.Profile.LevelOfMastery.Seasoned.longTermAndMidTermAchievedOrLongTermGoalsAchieved)
            ])
        case .unstoppable:
            return LimitsLevel(limitPoint: SimpleLevel(type: .points(2000), description: L10n.Profile.LevelOfMastery.points(2000)),
                               limitsGoal: [
                                SimpleLevel(type: .goals(goalMid: 7, goalLong: 1), description: L10n.Profile.LevelOfMastery.Unstoppable.longTermAndLongTermGoalsAchievedAndMidTermAchieved),
                                SimpleLevel(type: .goals(goalMid: 0, goalLong: 3), description: L10n.Profile.LevelOfMastery.Unstoppable.longTermAndLongTermGoalsAchievedAndMidTermAchieved)
            ])
        }
    }
    
}

class LevelOfMasteryViewController: UIViewController, ViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var footerView: LevelOfMasteryFooterView!
    
    typealias Presenter = LevelOfMasteryPresenter
    typealias Configurator = LevelOfMasteryConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
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
    }

}

extension LevelOfMasteryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let level = presenter.levels[indexPath.row]
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as LevelOfMasteryTableViewCell
        cell.config(level: level)
        return cell
    }
    
}
