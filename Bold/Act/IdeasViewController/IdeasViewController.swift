//
//  IdeasViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

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
