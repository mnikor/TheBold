//
//  ArchivedGoalsViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

private struct Constants {
    struct SizeCell {
        static let height : CGFloat = 181
    }
    struct Insets {
        static let topCell : CGFloat = 30
        static let rightLeftIndentCell : CGFloat = 20
    }
    struct Spacing {
        static let betweenHorizCell : CGFloat = 12
        static let betweenVertCell: CGFloat = 25
    }
}


class ArchivedGoalsViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ArchivedGoalsPresenter
    typealias Configurator = ArchivedGoalsConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = Configurator()
    
    @IBOutlet weak var segmentControl: WMSegment!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var currentItems : [GoalEntity] = {
        return goalItems
    }()
    
    lazy var goalItems : [GoalEntity] = {
        return [GoalEntity(type: .launchStartUp, active: .completed, progress: 0, total: 0),
                GoalEntity(type: .Community, active: .failed, progress: 2, total: 5),
                GoalEntity(type: .Marathon, active: .failed, progress: 3, total: 4),
                GoalEntity(type: .BuildHouseForParents, active: .failed, progress: 2, total: 7)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
        configSegmentControl()
        configureNavigationBar()
        registerXibs()
    }
    
    func registerXibs() {
        collectionView.registerNib(GoalCollectionViewCell.self)
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
        label.text = L10n.Profile.archivedGoals
        return label
    }
    
    @objc private func didTapAtBackBarButtonItem(_ sender: UIBarButtonItem) {
        presenter.input(.close)
    }
    
    func configSegmentControl() {
        segmentControl.selectorType = .bottomBar
        segmentControl.buttonTitles = "\(L10n.all),\(L10n.Profile.ArchivedGoals.completed),\(L10n.Profile.ArchivedGoals.failed)"
        segmentControl.textColor = ColorName.typographyBlack75.color
        segmentControl.selectorTextColor = ColorName.primaryBlue.color
        segmentControl.selectorColor = ColorName.primaryBlue.color
    }
    
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("all")
            currentItems = goalItems
        case 1:
            print("completed")
            currentItems = goalItems.filter({ (item) -> Bool in
                return item.active == .completed
            })
        case 2:
            print("failed")
            currentItems = goalItems.filter({ (item) -> Bool in
                return item.active == .failed
            })
        default:
            print("default item")
        }
        collectionView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArchivedGoalsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as GoalCollectionViewCell
        cell.configCell(type: currentItems[indexPath.row])
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ArchivedGoalsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width / 2 - Constants.Insets.rightLeftIndentCell - Constants.Spacing.betweenHorizCell / 2 , height: Constants.SizeCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.topCell, left: Constants.Insets.rightLeftIndentCell, bottom: 0, right: Constants.Insets.rightLeftIndentCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.betweenVertCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.betweenHorizCell
    }
}
