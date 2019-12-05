//
//  DownloadsViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum DownloadsCategory: CaseIterable {
    case all
    case meditation
    case peptalk
    case hypnosis
    case stories
    case lessons
}

class DownloadsViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = DownloadsPresenter
    typealias Configurator = DownloadsConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    @IBOutlet weak var segmentedtControl: ZSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var downloads: [DownloadsEntity] = []
    
    private var selectedContent: ActivityContent?
    private var selectedCategory: DownloadsCategory = .all
    
    private var currentDownloads: [DownloadsEntity] {
        switch selectedCategory {
        case .all:
            return downloads
        case .meditation:
            return downloads.filter { $0.type == .meditation }
        case .peptalk:
            return downloads.filter { $0.type == .pepTalk }
        case .hypnosis:
            return downloads.filter { $0.type == .hypnosis }
        case .stories:
            return downloads.filter { $0.type == .stories }
        case .lessons:
            return downloads.filter { $0.type == .lessons }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        tableView.tableFooterView = UIView()
        configureNavigationBar()
        registerXibs()
        configSegmentControl()
        prepareDataSource()
    }
    
    func registerXibs() {
        tableView.registerNib(DownloadTableViewCell.self)
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
    
    func prepareDataSource() {
        presenter.input(.prepareDataSource(completion: { [weak self] content in
            guard let self = self else { return }
            self.downloads = content.compactMap { DownloadsEntity(imagePath: $0.imageURL, title: $0.title, type: self.feelType(from: $0.type), group: $0.type.rawValue.capitalized, content: $0) }
            self.tableView.reloadData()
        }))
    }
    
    private func feelType(from contentType: ContentType) -> FeelTypeCell {
        switch contentType {
        case .hypnosis:
            return .hypnosis
        case .lesson:
            return .lessons
        case .meditation:
            return .meditation
        case .preptalk:
            return .pepTalk
        case .quote:
            return .citate
        case .story:
            return .stories
        }
    }
    
    private func prepareTitleView() -> UILabel {
        let label = UILabel()
        label.font = FontFamily.MontserratMedium.regular.font(size: 17)
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3607843137, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = L10n.Profile.downloads
        return label
    }
    
    @objc private func didTapAtBackBarButtonItem(_ sender: UIBarButtonItem) {
        presenter.input(.close)
    }
    
    func configSegmentControl() {
        let titles = [L10n.all,
                      FeelTypeCell.meditation.titleText()!,
                      FeelTypeCell.pepTalk.titleText()!,
                      FeelTypeCell.hypnosis.titleText()!,
                      FeelTypeCell.stories.titleText()!,
                      FeelTypeCell.lessons.titleText()!]
        segmentedtControl.backgroundColor = UIColor.white
        segmentedtControl.bounces = true
        segmentedtControl.textColor = ColorName.typographyBlack75.color
        segmentedtControl.textSelectedColor = ColorName.primaryBlue.color
        segmentedtControl.delegate = self
        segmentedtControl.setTitles(titles, style: .adaptiveSpace(30))
    }
    
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDownloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as DownloadTableViewCell
        cell.config(downloads: currentDownloads[indexPath.row], action: false)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let content = currentDownloads[indexPath.row].content
        selectedContent = content
        presenter.input(.showDetails(content))
    }
    
}

extension DownloadsViewController: ZSegmentedControlSelectedProtocol {
    
    func segmentedControlSelectedIndex(_ index: Int, animated: Bool, segmentedControl: ZSegmentedControl) {
        selectedCategory = DownloadsCategory.allCases[index]
        tableView.reloadData()
    }
}

extension DownloadsViewController: DownloadTableViewCellDelegate {

    func tapThreeDots(item: DownloadsEntity) {
        print("tapThreeDots")
        
        let action = DownloadsActionViewController.createController(item: item, tapAddPlan: { [weak self] in
            let vc = AddActionPlanViewController.createController(contentID: String(item.content.id), tapOk: { [weak self] in
                
            })
            self?.dismiss(animated: true)
            self?.present(vc, animated: true)
        }) { [weak self] in
            DataSource.shared.deleteContent(content: item.content)
            self?.downloads.removeAll(where: { $0.content.id == item.content.id })
            self?.tableView.reloadData()
            self?.dismiss(animated: true)
        }
        action.presentedBy(self)
    }
}

extension DownloadsViewController: PlayerViewControllerDelegate {
    func saveContent() {
        guard let content = selectedContent else { return }
        DataSource.shared.saveContent(content: content)
    }
    
    func removeFromCache() {
        guard let content = selectedContent else { return }
        DataSource.shared.deleteContent(content: content)
    }
    
    func likeContent(_ isLiked: Bool) {
        guard let content = selectedContent else { return }
    }
    
}

struct DownloadsEntity {
    let imagePath: String?
    let title: String
    let type: FeelTypeCell
    let group: String
    let content: ActivityContent
}
