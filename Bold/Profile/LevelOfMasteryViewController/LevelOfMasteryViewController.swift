//
//  LevelOfMasteryViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum LevelOfMasteryType {
    case apprentice
    case risingPower
    case intermidiate
    case seasoned
    case unstoppable
    
    var iconImage : UIImage {
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
    
    var titleText : String {
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
    
}

class LevelOfMasteryViewController: UIViewController, ViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var footerView: LevelOfMasteryFooterView!
    
    typealias Presenter = LevelOfMasteryPresenter
    typealias Configurator = LevelOfMasteryConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    lazy var levels: [LevelOfMasteryEntity] = {
        
        return [LevelOfMasteryEntity(type: .apprentice,
                              isLock: false,
                              progress: 75,
                              params: [CheckLevelEntity(checkPoint: true, titleText: "400 of 500 points", points: 500, timeDuration: nil)]),
        LevelOfMasteryEntity(type: .risingPower,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "300 points", points: 300, timeDuration: nil),
                                      CheckLevelEntity(checkPoint: true, titleText: "1 mid-term goal achieved", points: nil, timeDuration: Date()),
            ]),
        LevelOfMasteryEntity(type: .intermidiate,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "600 points", points: 600, timeDuration: nil),
                                      CheckLevelEntity(checkPoint: true, titleText: "3 mid-term goals", points: nil, timeDuration: Date()),
            ]),
        LevelOfMasteryEntity(type: .seasoned,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "Min 1000 points", points: 1000, timeDuration: nil),
                                      CheckLevelEntity(checkPoint: true, titleText: "1 long-term and 5 mid-term achieved. Or 2 long-term goals achieved", points: nil, timeDuration: Date()),
            ]),
        LevelOfMasteryEntity(type: .unstoppable,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "2000 points", points: 2000, timeDuration: nil),
                                      CheckLevelEntity(checkPoint: true, titleText: "3 long-term and 1 long-term goals achieved and 7 mid-term achieved", points: nil, timeDuration: Date()),
            ])]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        configureNavigationBar()
        setupTableView()
        registerXibs()
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
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let level = levels[indexPath.row]
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as LevelOfMasteryTableViewCell
        cell.config(level: level)
        return cell
    }
    
}

struct LevelOfMasteryEntity {
    var type: LevelOfMasteryType
    var isLock: Bool
    var progress: Int
    var params: [CheckLevelEntity]
}

struct CheckLevelEntity {
    var checkPoint: Bool = false
    var titleText: String
    var points: Int?
    var timeDuration: Date?
}
