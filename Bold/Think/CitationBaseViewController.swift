//
//  CitationBaseViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CitationBaseViewController: UIViewController {
    @IBOutlet weak var pageControl: CustomDotsPageControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    var quotes: [ActivityContent] = []
    fileprivate var isShownPremium = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let tutorialPageViewController = segue.destination as? CitationPageViewController {
            tutorialPageViewController.quotes = quotes
            tutorialPageViewController.pageDelegate = self
        }
    }
    
    func showPremiumController() {
        let vc = StoryboardScene.Settings.premiumViewController.instantiate()
        present(vc, animated: true, completion: nil)
    }

}

extension CitationBaseViewController: CitationPageViewControllerDelegate {
    func citationPageViewController(_ citationPageViewController: CitationPageViewController, numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func citationPageViewController(_ citationPageViewController: CitationPageViewController, currentPage index: Int) {
        pageControl.currentPage = index
        
        if index == 4 && !isShownPremium {
            isShownPremium = true
            showPremiumController()
        }
    }
}
