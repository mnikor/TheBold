//
//  AccountDetailsViewController.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum AccountDetailsItem: String, CaseIterable {
    case firstName = "Add your first name"
    case lastName = "Add your second name"
    case email = "Enter your email"
    case password = "Enter your password"
}

enum AccountDetailsHeaderItem: String, CaseIterable {
    case firstName = "First name"
    case lastName = "Last name"
    case email = "Email"
    case password = "Password"
}

enum AccountDetailsViewInput {
    case updateCell(item: AccountDetailsItem, viewModel: ButtonedTitleViewModel)
}

protocol AccountDetailsViewInputProtocol: ViewProtocol {
    func input(_ inputCase: AccountDetailsViewInput)
}

class AccountDetailsViewController: UIViewController, AccountDetailsViewInputProtocol {
    typealias Presenter = AccountDetailsPresenter
    typealias Configurator = AccountDetailsConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: [AccountDetailsItem: ButtonedTitleViewModel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        configure()
    }
    
    private func configure() {
        configureNavigationBar()
        prepareDataSource()
        configureTableView()
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
        label.font = FontFamily.MontserratMedium.regular.font(size: 16.5)
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3607843137, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = "Account details"
        return label
    }
    
    private func prepareDataSource() {
        presenter.input(.prepareDataSource({ [weak self] in self?.dataSource = $0 }))
    }
    
    private func configureTableView() {
        tableView.registerReusableCell(ButtonedTitleCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func input(_ inputCase: AccountDetailsViewInput) {
        switch inputCase {
        case .updateCell(item: let item, viewModel: let viewModel):
            updateCell(item: item, viewModel: viewModel)
        }
    }
    
    private func updateCell(item: AccountDetailsItem, viewModel: ButtonedTitleViewModel) {
        dataSource[item] = viewModel
        guard let section = AccountDetailsItem.allCases.firstIndex(of: item)
            else { return }
        reloadRows(at: [IndexPath(row: 0, section: section)])
    }
    
    private func reloadRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths, with: .none)
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let item = sender as? AccountDetailsItem
            else { return }
        presenter.input(.prepareFor(segue: segue, sender: (item: item, value: dataSource[item]?.title ?? "")))
    }
    
    @objc private func didTapAtBackBarButtonItem(_ sender: UIBarButtonItem) {
        presenter.input(.back)
    }
    
}

extension AccountDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AccountDetailsItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ButtonedTitleCell = tableView.dequeReusableCell(indexPath: indexPath)
        let item = AccountDetailsItem.allCases[indexPath.section]
        if let viewModel = dataSource[item] {
            cell.configure(with: viewModel)
        }
        cell.backgroundColor = .white
        cell.delegate = self
        return cell
    }
    
}

extension AccountDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AccountDetailsItem.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = FontFamily.MontserratMedium.regular.font(size: 14.5)
            headerView.textLabel?.textColor = #colorLiteral(red: 0.4196078431, green: 0.4509803922, blue: 0.5450980392, alpha: 1)
            headerView.textLabel?.text = AccountDetailsHeaderItem.allCases[section].rawValue
        }
    }
    
}

extension AccountDetailsViewController: ButtonedTitleCellDelegate {
    func buttonedTitleCellDidTapAtButton(_ cell: ButtonedTitleCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = AccountDetailsItem.allCases[indexPath.section]
        presenter.input(.edit(item: item))
    }
    
}

extension AccountDetailsViewController: EditAccountDetailsViewControllerDelegate {
    func item(_ item: AccountDetailsItem, didChangeValue to: String?) {
        presenter.input(.updateItem(item: item, value: to))
    }
    
}
