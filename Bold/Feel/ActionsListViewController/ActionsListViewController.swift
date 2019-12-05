//
//  ActionsListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ActionCellType {
    case action
    case songOrListen
    case manageIt
    
}

class ActionsListViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ActionsListPresenter
    typealias Configurator = ActionsListConfigurator
    
    var presenter: ActionsListPresenter!
    var configurator: ActionsListConfigurator! = ActionsListConfigurator()

    @IBOutlet weak var highNavigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    var typeVC : FeelTypeCell = .meditation
    
    var actions: [ActionEntity] = []
    
    private var selectedContent: ActivityContent?
    
    private let loader = LoaderView(frame: .zero)
    private var viewDidAppearAnimated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        highNavigationBar.configItem(title: typeVC.titleText()!, titleImage: .info, leftButton: .back, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
        registerXibs()
        prepareDataSource()
    }
    
    func registerXibs() {
        tableView.registerNib(ActionTableViewCell.self)
        tableView.registerNib(ListenOrReadTableViewCell.self)
        tableView.registerNib(ManageItTableViewCell.self)
    }
    
    private func prepareDataSource() {
        loader.start(in: self.view)
        presenter.input(.prepareDataSource(type: typeVC, completion: { [weak self] actions in
            self?.loader.stop()
            self?.actions = actions
            self?.tableView.reloadData()
        }))
    }
    
}


// MARK:- NavigationViewDelegate

extension ActionsListViewController: NavigationViewDelegate {
    
    func tapLeftButton() {
        presenter.input(.back)
    }
    
    func tapInfoAction() {
        presenter.input(.info(typeVC))
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource

extension ActionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch actions[indexPath.row].type {
        case .action:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionTableViewCell
            cell.config(item: actions[indexPath.row])
            cell.delegate = self
            return cell
        case .songOrListen:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ListenOrReadTableViewCell
            cell.config(type: .unlockListenPreview)
            return cell
        case .manageIt:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as ManageItTableViewCell
            cell.config(type: .baseThreeCells)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = cell.frame.height
        if viewDidAppearAnimated {
            let animation = TableViewCellAnimationFactory.moveUp(rowHeight: height, duration: 0.2, delayFactor: 0.07)
            let animator = TableViewCellAnimator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        } else {
            let animation = TableViewCellAnimationFactory.slideIn(duration: 0.15, delayFactor: 0.05)
            let animator = TableViewCellAnimator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
            viewDidAppearAnimated = tableView.frame.height <= (CGFloat(indexPath.row + 1) * height)
        }
    }
    
}


//MARK:- ManageItTableViewCellDelegate

extension ActionsListViewController: ManageItTableViewCellDelegate {
    func tapBlueButton(type: ListenOrReadCellType) {
        switch type {
        case .startAddToPlan:
            presenter.input(.start)
        case .unlockListenPreview:
            presenter.input(.unlockListenPreview)
        case .unlockReadPreview:
            presenter.input(.unlockReadPreview)
        }
    }
    
    func tapCleanButton(type: ListenOrReadCellType) {
        switch type {
        case .startAddToPlan:
            presenter.input(.addActionPlan)
        case .unlockListenPreview:
            presenter.input(.listenPreview)
        case .unlockReadPreview:
            presenter.input(.readPreview)
        }
    }
}


//MARK:- ActionTableViewCellDelegate

extension ActionsListViewController: ActionTableViewCellDelegate {

    func tapLeftHeaderButton() {
        
        presenter.input(.unlockActionCard)
        
        print("Unlock")
    }
    
    func tapThreeDotsButton(item: ActionEntity) {
        
        presenter.input(.share)
        
        print("Share")
//        self.shareContent(item: nil)
    }
    
    func tapDownloadButton(cell: ActionTableViewCell) {
        
        presenter.input(.download)
        
        print("download")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = actions[indexPath.row]
        item.download = !item.download
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tapLikeButton(cell: ActionTableViewCell) {
        
        presenter.input(.like)
        
        print("like")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = actions[indexPath.row]
        item.like = !item.like
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tapAddActionPlanButton() {
        presenter.input(.addActionPlan)
    }
}

extension ActionsListViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let content = actions[indexPath.row].data
        
        switch content.type {
        case .lesson, .story:
            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
            vc.viewModel = DescriptionViewModel.map(activityContent: content)
            selectedContent = content
            vc.audioPlayerDelegate = self
            navigationController?.present(vc, animated: true, completion: nil)
        default:
            AudioService.shared.tracks = content.audioTracks
            AudioService.shared.image = .path(content.imageURL)
            AudioService.shared.startPlayer(isPlaying: content.type != .meditation)
            AudioService.shared.playerDelegate = self
        }
        
//        if actions[indexPath.row].type == .action {
//            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
//            vc.content = actions[indexPath.row].data
//            navigationController?.present(vc, animated: true, completion: nil)
//        }
        
    }
    
}

extension ActionsListViewController: PlayerViewControllerDelegate {
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
