//
//  FeelViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class FeelViewController: UIViewController, SideMenuItemContent, ViewProtocol {
    
    @IBOutlet weak var highNavigationBar: NavigationView!
    @IBOutlet weak var progressView: ProgressHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = FeelPresenter
    typealias Configurator = FeelConfigurator
    
    var presenter : Presenter!
    var configurator : Configurator! = FeelConfigurator()
    var contentTypes: [ContentType] {
        return [.meditation, .hypnosis, .preptalk]
    }
    var items: [FeelEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        navigationController?.navigationBar.isHidden = true
        highNavigationBar.configItem(title: L10n.Feel.feelBold, titleImage: .none, leftButton: .showMenu, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView()
        registerXibs()
        prepareDataSource()
    }
    
    func registerXibs() {
        tableView.registerNib(ActionCollectionTableViewCell.self)
    }
    
    private func prepareDataSource() {
        presenter.input(.prepareDataSource(types: contentTypes, completion: { [weak self] items in
            self?.items = items
            self?.tableView.reloadData()
        }))
    }
    
}


// MARK:- NavigationViewDelegate

extension FeelViewController: NavigationViewDelegate {
    func tapLeftButton() {
        presenter.input(.menuShow)
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource

extension FeelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionCollectionTableViewCell
        cell.delegate = self
        cell.config(entity: items[indexPath.row])
        cell.cellBackground(indexPath: indexPath)
        return cell
    }
}


// MARK:- ActionCollectionTableViewCellDelegate

extension FeelViewController: ActionCollectionTableViewCellDelegate {
    
    @objc func tapItemCollection() {
        print("Show item")
        presenter.input(.showPlayer)
    }
    
    func tapShowAll(typeCells: FeelTypeCell)  {
        print("Show all")
        presenter.input(.showAll(typeCells))
    }
    
    func showAll(typeCells: FeelTypeCell) {
        performSegue(withIdentifier: StoryboardSegue.Feel.showItem.rawValue, sender: typeCells)
    }
    
}


// MARK:- Segue

extension FeelViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Feel.showItem.rawValue {
            let vc = segue.destination as! ActionsListViewController
            guard let type = sender as? FeelTypeCell else {return}
            vc.typeVC = type
        }
    }
}


