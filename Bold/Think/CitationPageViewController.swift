//
//  CitationPageViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CitationPageViewControllerDelegate : class {
    func citationPageViewController(_ citationPageViewController: CitationPageViewController, numberOfPages: Int)
    func citationPageViewController(_ citationPageViewController: CitationPageViewController, currentPage index: Int)
}

class CitationPageViewController: UIPageViewController {

    weak var pageDelegate: CitationPageViewControllerDelegate?
    
    var quotes: [ActivityContent] = []
    
    private var isPremium = false
    private let disposeBag = DisposeBag()
    private var lastIndex : Int = 0
    
    private var orderedViewControllers: [UIViewController] = []
    
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
        
        subscribeToChangePremium()
    }
    
    private func configurePages() {
        configureOrderedViewControllers()
        
        pageDelegate?.citationPageViewController(self, numberOfPages: orderedViewControllers.count)
        
        if lastIndex != 0 {
            let vController = orderedViewControllers[lastIndex]
            setViewControllers([vController], direction: .forward, animated: true, completion: nil)
            return
        }
        
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
    
    private func subscribeToChangePremium() {
        
        DataSource.shared.changePremium.subscribe(onNext: {[weak self] (isPremium) in

            self?.isPremium = true
            self?.configurePages()
            if let ss = self {
                ss.pageDelegate?.citationPageViewController(ss, currentPage: ss.lastIndex)
            }
        }).disposed(by: disposeBag)
    }
}

extension CitationPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
            pageDelegate?.citationPageViewController(self, currentPage: index)
            lastIndex = index
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
