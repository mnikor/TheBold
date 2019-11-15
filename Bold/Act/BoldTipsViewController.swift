//
//  BoldTipsViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class BoldTipsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var getIdeasButton: UIButton!
    
    weak var delegate: IdeasViewControllerDeleagte?
    var selectIdea: IdeasType = .marathon
    
    @IBOutlet weak var tapGetIdeasButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGetIdeasButton.addTarget(self,
                                    action: #selector(getIdeas),
                                    for: .touchUpInside)
    }
    
    @objc private func getIdeas() {
        let ideasVC = StoryboardScene.Act.ideasViewController.instantiate()
        ideasVC.delegate = delegate
        ideasVC.selectIdea = selectIdea
        navigationController?.pushViewController(ideasVC, animated: true)
    }

}
