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
    
    private var isPremium = false
    
    private var orderedViewControllers: [UIViewController] = []
    
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [createArrayViewController(type: .orange),
//        createArrayViewController(type: .blue),
//        createArrayViewController(type: .ink)]
//    }()
    
    private func createArrayViewController(quote: ActivityContent, color: ColorGoalType) -> UIViewController {
        
        let vc = StoryboardScene.Think.citationViewController.instantiate() as CitationViewController
        vc.quote = quote
        vc.color = color
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        dataSource = self
        delegate = self
        
        if quotes.count > 0 { configurePages() }
        else { prepareData() }
        
    }
    
    private func configurePages() {
        configureOrderedViewControllers()
        
        pageDelegate?.citationPageViewController(self, numberOfPages: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func prepareData() {
        
        NetworkService.shared.getContent(with: .quote) { result in
            switch result {
            case .failure(_):
                break
            case .success(let content):
                //completion?(content)
                self.quotes = content
                self.configurePages()
            }
        }
    }
    
    private func configureOrderedViewControllers() {
        orderedViewControllers = []
        
        let user = DataSource.shared.readUser()
        isPremium = user.premiumOn
        
        let number = isPremium ? quotes.count : 3
        
        for index in (0 ..< number) {
            orderedViewControllers.append(createArrayViewController(quote: quotes[index], color: ColorGoalType(rawValue: Int16((index % 6) + 1))!))
        }
        
        if !user.premiumOn { appendPremiumController() }
        
    }
    
    func appendPremiumController() {
        let vc = StoryboardScene.Settings.premiumViewController.instantiate()
        vc.fromThoughts = true
        orderedViewControllers.append(vc)
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
        
//        if viewControllerIndex > 3 && !isPremium { return nil }
        
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
