//
//  ProfileViewController.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum UserProfileSection: CaseIterable {
    case profileHeader
    case additionalInfo
    case rate
    case logout
}

enum UserProfileListItem {
    case imagedTitleSubtitle(viewModel: ImagedTitleSubtitleViewModel)
    case imagedTitle(viewModel: ImagedTitleViewModel)
    case underlinedImageTitle(viewModel: UnderlinedImageTitleViewModel)
    case label(title: String)
}

enum ProfileAdditionalInfoCell: String, CaseIterable {
    case accountDetails = "Account details"
    case archivedGoals = "Archived goals"
    case downloads = "Downloads"
    case calendar = "Calendar & History"
}

enum ProfileViewInput {
    
}

protocol ProfileViewInputProtocol: ViewProtocol {
    func input(_ inputCase: ProfileViewInput)
}

typealias UserProfileDataSourceItem = (section: UserProfileSection, items: [UserProfileListItem])

class ProfileViewController: UIViewController, SideMenuItemContent, ProfileViewInputProtocol {
    typealias Presenter = ProfilePresenter
    typealias Configurator = ProfileConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    @IBOutlet private weak var highNavigationBar: NavigationView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: [UserProfileDataSourceItem] = []
    
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
        navigationController?.navigationBar.isHidden = true
        highNavigationBar.configItem(title: L10n.Feel.feelBold, titleImage: .none, leftButton: .showMenu, rightButton: .none)
        highNavigationBar.deleagte = self
    }
    
    private func configureTableView() {
        tableView.registerReusableCell(ConfigurableTableViewCell<ImagedTitleSubtitleView>.self)
        tableView.registerReusableCell(ConfigurableTableViewCell<ImagedTitleView>.self)
        tableView.registerReusableCell(ConfigurableTableViewCell<UnderlinedImageTitleView>.self)
        tableView.registerReusableCell(ConfigurableTableViewCell<ConfigurableLabel>.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func prepareDataSource() {
        presenter.input(.prepareDataSource({ [weak self] in self?.dataSource = $0 }))
    }
    
    func input(_ inputCase: ProfileViewInput) {
        switch inputCase {
            
        }
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.section].items[indexPath.row]
        switch item {
        case .imagedTitleSubtitle(viewModel: let viewModel):
            let cell: ConfigurableTableViewCell<ImagedTitleSubtitleView> = tableView.dequeReusableCell(indexPath: indexPath)
            cell.setCellCreateViewBlock({ return ImagedTitleSubtitleView() })
            cell.configure(with: viewModel)
            return cell
        case .imagedTitle(viewModel: let viewModel):
            let cell: ConfigurableTableViewCell<ImagedTitleView> = tableView.dequeReusableCell(indexPath: indexPath)
            cell.setCellCreateViewBlock({ return ImagedTitleView() })
            cell.configure(with: viewModel)
            return cell
        case .underlinedImageTitle(viewModel: let viewModel):
            let cell: ConfigurableTableViewCell<UnderlinedImageTitleView> = tableView.dequeReusableCell(indexPath: indexPath)
            cell.setCellCreateViewBlock({ return UnderlinedImageTitleView() })
            cell.configure(with: viewModel)
            return cell
        case .label(title: let title):
            let cell: ConfigurableTableViewCell<ConfigurableLabel> = tableView.dequeReusableCell(indexPath: indexPath)
            cell.setCellCreateViewBlock({ return ConfigurableLabel() })
            cell.configure(with: title)
            cell.backgroundColor = .white
            cell.setupUI(insets: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0))
            return cell
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = dataSource[indexPath.section]
        switch section.section {
        case .profileHeader:
            presenter.input(.profileInfo)
        case .additionalInfo:
            didSelectAdditionalItem(at: indexPath.row)
        case .rate:
            presenter.input(.rateApp)
        case .logout:
            presenter.input(.logout)
        }
    }
    
    private func didSelectAdditionalItem(at row: Int) {
        switch ProfileAdditionalInfoCell.allCases[row] {
        case .accountDetails:
            presenter.input(.accountDetails)
        case .archivedGoals:
            presenter.input(.archivedGoals)
        case .downloads:
            presenter.input(.downloads)
        case .calendar:
            presenter.input(.calendar)
        }
    }
    
}

extension ProfileViewController: NavigationViewDelegate {
    func tapLeftButton() {
        showSideMenu()
    }

}
