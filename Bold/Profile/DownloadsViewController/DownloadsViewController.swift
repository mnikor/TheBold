//
//  DownloadsViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class DownloadsViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = DownloadsPresenter
    typealias Configurator = DownloadsConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    @IBOutlet weak var segmentedtControl: ZSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var currentDownloads: [DownloadsEntity] = {
        return downloads
    }()
    
    lazy var downloads: [DownloadsEntity] = {
        return [DownloadsEntity(image: Asset.serfer.image, title: "Managing team", type: .lessons, group: "Lesson"),
                DownloadsEntity(image: Asset.serfer.image, title: "Leading with purpose", type: .meditation, group: "Meditation"),
                DownloadsEntity(image: Asset.serfer.image, title: "Managing conﬂict", type: .lessons, group: "Lesson"),
                DownloadsEntity(image: Asset.serfer.image, title: "Managing uncertainty", type: .meditation, group: "Meditation"),
                DownloadsEntity(image: Asset.serfer.image, title: "Managing team", type: .lessons, group: "Lesson"),
                DownloadsEntity(image: Asset.serfer.image, title: "Leading with purpose", type: .meditation, group: "Meditation"),
                DownloadsEntity(image: Asset.serfer.image, title: "Managing conﬂict", type: .lessons, group: "Lesson"),
                DownloadsEntity(image: Asset.serfer.image, title: "Managing uncertainty", type: .meditation, group: "Meditation")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        tableView.tableFooterView = UIView()
        configureNavigationBar()
        registerXibs()
        configSegmentControl()
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
}

    

extension DownloadsViewController: ZSegmentedControlSelectedProtocol {
    
    func segmentedControlSelectedIndex(_ index: Int, animated: Bool, segmentedControl: ZSegmentedControl) {
        print("select index = \(index)")
        
        switch index {
        case 0:
            print("all")
            currentDownloads = downloads
        case 1:
            print("meditation")
            currentDownloads = downloads.filter({ (item) -> Bool in
                return item.type == .meditation
            })
        case 2:
            print("pepTalk")
            currentDownloads = downloads.filter({ (item) -> Bool in
                return item.type == .pepTalk
            })
        case 3:
            print("hypnosis")
            currentDownloads = downloads.filter({ (item) -> Bool in
                return item.type == .hypnosis
            })
        case 4:
            print("stories")
            currentDownloads = downloads.filter({ (item) -> Bool in
                return item.type == .stories
            })
        case 5:
            print("lessons")
            currentDownloads = downloads.filter({ (item) -> Bool in
                return item.type == .lessons
            })
        default:
            print("default item")
        }
        tableView.reloadData()
    }
}

extension DownloadsViewController: DownloadTableViewCellDelegate {

    func tapThreeDots(item: DownloadsEntity) {
        print("tapThreeDots")
        
        let action = DownloadsActionViewController.createController(item: item, tapAddPlan: {
            print("Add to Plan")
        }) {
            print("Delete")
        }
        action.presentedBy(self)
    }
}

struct DownloadsEntity {
    let image: UIImage
    let title: String
    let type: FeelTypeCell
    let group: String
}
