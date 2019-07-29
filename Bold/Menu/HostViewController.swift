//
// HostViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
//import InteractiveSideMenu

/**
 HostViewController is container view controller, contains menu controller and the list of relevant view controllers.

 Responsible for creating and selecting menu items content controlers.
 Has opportunity to show/hide side menu.
 */
class HostViewController: MenuContainerViewController {

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)

        // Instantiate menu view controller by identifier
        self.menuViewController = StoryboardScene.Menu.storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as? MenuViewController

        // Gather content items controllers
        self.contentViewControllers = contentControllers()

        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(contentViewControllers.first!)

        self.currentItemOptions.cornerRadius = 10.0
        
    }
    
    class func showController(newVC: UIViewController) {
        
        guard let hoostVC = UIApplication.shared.keyWindow?.rootViewController as? HostViewController else {
            return
        }
        
        if let navController = newVC as? UINavigationController {
            hoostVC.selectContentViewController(navController)
        }
        
//        if let _ = newVC as? ActionsListViewController {
//            guard let feelVC = StoryboardScene.Feel.storyboard.instantiateInitialViewController()
//                else {  return }
//            if let navController = feelVC as? UINavigationController {
//                navController.viewControllers.append(newVC)
//            }
//            hoostVC.selectContentViewController(feelVC)
//        }else {
//            if let navController = newVC as? UINavigationController {
//                hoostVC.selectContentViewController(navController)
//            }
//        }
        
//        if let menuContainerViewController = parent as? MenuContainerViewController {
//            menuContainerViewController.showSideMenu()
//        } else if let navController = parent as? UINavigationController,
//            let menuContainerViewController = navController.parent as? MenuContainerViewController {
//            menuContainerViewController.showSideMenu()
//        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Options to customize menu transition animation.
        var options = TransitionOptions()

        // Animation duration
        options.duration = size.width < size.height ? 0.4 : 0.6

        // Part of item content remaining visible on right when menu is shown
        options.visibleContentWidth = size.width / 6
        self.transitionOptions = options
    }

    private func contentControllers() -> [UIViewController] {
        guard let homeController = StoryboardScene.Home.storyboard.instantiateInitialViewController()
            else { fatalError("Could not instantiate initial storyboard with name: \(StoryboardScene.Home.storyboardName)")
        }
        guard let feelController = StoryboardScene.Feel.storyboard.instantiateInitialViewController()
            else {  fatalError("Could not instantiate initial storyboard with name: \(StoryboardScene.Home.storyboardName)")
        }
        guard let thinkController = StoryboardScene.Think.storyboard.instantiateInitialViewController()
            else {  fatalError("Could not instantiate initial storyboard with name: \(StoryboardScene.Think.storyboardName)")
        }
        guard let actController = StoryboardScene.Act.storyboard.instantiateInitialViewController()
            else {  fatalError("Could not instantiate initial storyboard with name: \(StoryboardScene.Act.storyboardName)")
        }
        guard let settingsController = StoryboardScene.Settings.storyboard.instantiateInitialViewController()
            else {  fatalError("Could not instantiate initial storyboard with name: \(StoryboardScene.Settings.storyboardName)")
        }
        guard let profileController = StoryboardScene.Profile.storyboard.instantiateInitialViewController()
            else {  fatalError("Could not instantiate initial storyboard with name: \(StoryboardScene.Profile.storyboardName)")
        }

        return [homeController, feelController, thinkController, actController, settingsController, profileController]
    }
}
