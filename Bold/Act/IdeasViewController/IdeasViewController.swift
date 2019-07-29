//
//  IdeasViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum IdeasType {
    case marathon
    case triathlon
    case charityProject
    case writeBook
    case quitSmoking
    case publicSpeech
    case skyDiving
    case launchStartUp
    case competeToWin
    case startNewProject
    case killProject
    case findNewJob
    case makeDiscovery
    case inventSomething
    case income
    case masterSkill
    case none
    
    func iconImage() -> UIImage? {
        switch self {
        case .marathon:
            return Asset.marathon.image
        case .triathlon:
            return Asset.triathlon.image
        case .charityProject:
            return Asset.emotional.image
        case .writeBook:
            return Asset.writeBook.image
        case .quitSmoking:
            return Asset.smoking.image
        case .publicSpeech:
            return Asset.publicSpeech.image
        case .skyDiving:
            return Asset.skyDiving.image
        case .launchStartUp:
            return Asset.startUp.image
        case .competeToWin:
            return Asset.completeToWin.image
        case .startNewProject:
            return Asset.startNewProject.image
        case .killProject:
            return Asset.killProject.image
        case .findNewJob:
            return Asset.findJob.image
        case .makeDiscovery:
            return Asset.makeDiscovery.image
        case .inventSomething:
            return Asset.inventSomethings.image
        case .income:
            return Asset.income.image
        case .masterSkill:
            return Asset.masterSkill.image
        default:
            return nil
        }
    }
    
    func titleText() -> String? {
        switch self {
        case .marathon:
            return L10n.Act.Ideas.marathon
        case .triathlon:
            return L10n.Act.Ideas.triathlon
        case .charityProject:
            return L10n.Act.Ideas.charityProject
        case .writeBook:
            return L10n.Act.Ideas.writeBook
        case .quitSmoking:
            return L10n.Act.Ideas.quitSmoking
        case .publicSpeech:
            return L10n.Act.Ideas.publicSpeech
        case .skyDiving:
            return L10n.Act.Ideas.skyDiving
        case .launchStartUp:
            return L10n.Act.Ideas.launchStartUp
        case .competeToWin:
            return L10n.Act.Ideas.competeToWin
        case .startNewProject:
            return L10n.Act.Ideas.startNewProject
        case .killProject:
            return L10n.Act.Ideas.killProject
        case .findNewJob:
            return L10n.Act.Ideas.findNewJob
        case .makeDiscovery:
            return L10n.Act.Ideas.makeDiscovery
        case .inventSomething:
            return L10n.Act.Ideas.inventSomething
        case .income:
            return L10n.Act.Ideas.income
        case .masterSkill:
            return L10n.Act.Ideas.masterSkill
        default:
            return nil
        }
    }
}

protocol IdeasViewControllerDeleagte: class {
    func selectIdea(selectIdea: IdeasType)
}

class IdeasViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var footerView: IdeasFooterView!
    
    weak var delegate: IdeasViewControllerDeleagte?
    
    typealias Presenter = IdeasPresenter//IdeasInputPresenterProtocol
    typealias Configurator = IdeasConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = IdeasConfigurator()
    
    var selectIdea: IdeasType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.tableFooterView = UIView()
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        viewHeader.backgroundColor = ColorName.tableViewBackground.color
        tableView.tableHeaderView = viewHeader
        tableView.tableFooterView = footerView
        footerView.delegate = self
        registerXibs()
    }

    func registerXibs() {
        tableView.registerNib(IdeasTableViewCell.self)
    }
    
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension IdeasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as IdeasTableViewCell
        cell.config(type: presenter.item(for: indexPath.row), selectIdea: selectIdea)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectIdea = presenter.item(for: indexPath.row)
        delegate?.selectIdea(selectIdea: selectIdea)
        tableView.reloadData()
    }
}


//MARK:- IdeasFooterViewDelegate

extension IdeasViewController: IdeasFooterViewDelegate {
    
    func tapCancelButton() {
        presenter.input(.cancel)
    }
}
