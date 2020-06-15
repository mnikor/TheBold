//
//  ShareWithFriendsViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ShareTypeButton {
    case card
    case facebook
    case email
    case share
    
    func title() -> String {
        switch self {
        case .facebook:
            return L10n.Act.Share.facebook
        case .email:
            return L10n.Act.Share.sendEmail
        case .share:
            return L10n.Act.Share.share
        default:
            return String()
        }
    }
    
    func icon() -> UIImage {
        switch self {
        case .facebook:
            return Asset.facebookLogo.image
        case .email:
            return Asset.emailLogo.image
        case .share:
            return Asset.downloadLogo.image
        default:
            return UIImage()
        }
    }
}

private struct Constants {
    struct Identifier {
        static let cardCell : String = "ShareCardTableViewCell"
        static let buttonCell : String = "ShareButtonTableViewCell"
    }
}

class ShareWithFriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var items : [ShareTypeButton] = {
        return [.card, .facebook, .email, .share]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Act.Share.shareWithFriends
    }
    
    private func rgisterXibs() {
        tableView.register(ShareCardTableViewCell.self, forCellReuseIdentifier: Constants.Identifier.cardCell)
        tableView.register(ShareButtonTableViewCell.self, forCellReuseIdentifier: Constants.Identifier.buttonCell)
    }

}


    //MARK:- UITableViewDelegate, UITableViewDataSource

extension ShareWithFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch items[indexPath.row] {
        case .card:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.cardCell, for: indexPath) as! ShareCardTableViewCell
            cell.config(actionText: "Run 50km every morning", color: .orange)
            return cell
        case .email, .facebook, .share:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.buttonCell, for: indexPath) as! ShareButtonTableViewCell
            cell.config(type: items[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
}

    //MARK:- ShareButtonTableViewCellDelegate

extension ShareWithFriendsViewController: ShareButtonTableViewCellDelegate {
    
    func tapButton(shareType: ShareTypeButton) {
        print("Share type = \(shareType)")
    }
}
