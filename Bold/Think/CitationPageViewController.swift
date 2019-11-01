//
//  CitationPageViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol CitationPageViewControllerDelegate : class {
    func citationPageViewController(_ citationPageViewController: CitationPageViewController, numberOfPages: Int)
    func citationPageViewController(_ citationPageViewController: CitationPageViewController, currentPage index: Int)
}

class CitationPageViewController: UIPageViewController {

    weak var pageDelegate: CitationPageViewControllerDelegate?
    
    var quotes: [ActivityContent] = []
    
    private var orderedViewControllers: [UIViewController] = []
    
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [createArrayViewController(type: .orange),
//        createArrayViewController(type: .blue),
//        createArrayViewController(type: .ink)]
//    }()
    
    private func createArrayViewController(quote: ActivityContent) -> UIViewController {
        
        let vc = StoryboardScene.Think.citationViewController.instantiate() as CitationViewController
        vc.quote = quote
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        configureOrderedViewControllers()
        
        pageDelegate?.citationPageViewController(self, numberOfPages: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func configureOrderedViewControllers() {
        orderedViewControllers = quotes.compactMap { createArrayViewController(quote: $0) }
    }

}

extension CitationPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
            pageDelegate?.citationPageViewController(self, currentPage: index)
        }
    }
    
}

extension CitationPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}
