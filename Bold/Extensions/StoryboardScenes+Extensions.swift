// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Act: StoryboardType {
    internal static let storyboardName = "Act"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Act.self)

    internal static let boldTipsViewController = SceneType<Bold.BoldTipsViewController>(storyboard: Act.self, identifier: "BoldTipsViewController")

    internal static let calendarActionsListViewController = SceneType<Bold.CalendarActionsListViewController>(storyboard: Act.self, identifier: "CalendarActionsListViewController")

    internal static let createActionViewController = SceneType<Bold.CreateActionViewController>(storyboard: Act.self, identifier: "CreateActionViewController")

    internal static let createGoalViewController = SceneType<Bold.CreateGoalViewController>(storyboard: Act.self, identifier: "CreateGoalViewController")

    internal static let ideasViewController = SceneType<Bold.IdeasViewController>(storyboard: Act.self, identifier: "IdeasViewController")
  }
  internal enum AlertView: StoryboardType {
    internal static let storyboardName = "AlertView"

    internal static let addActionPlanViewController = SceneType<Bold.AddActionPlanViewController>(storyboard: AlertView.self, identifier: "AddActionPlanViewController")

    internal static let baseAlertViewController = SceneType<Bold.BaseAlertViewController>(storyboard: AlertView.self, identifier: "BaseAlertViewController")

    internal static let dateAlertViewController = SceneType<Bold.DateAlertViewController>(storyboard: AlertView.self, identifier: "DateAlertViewController")

    internal static let downloadsActionViewController = SceneType<Bold.DownloadsActionViewController>(storyboard: AlertView.self, identifier: "DownloadsActionViewController")

    internal static let editActionPlanViewController = SceneType<Bold.EditActionPlanViewController>(storyboard: AlertView.self, identifier: "EditActionPlanViewController")

    internal static let startActionViewController = SceneType<Bold.StartActionViewController>(storyboard: AlertView.self, identifier: "StartActionViewController")

    internal static let yearMonthAlertViewController = SceneType<Bold.YearMonthAlertViewController>(storyboard: AlertView.self, identifier: "YearMonthAlertViewController")
  }
  internal enum Auth: StoryboardType {
    internal static let storyboardName = "Auth"

    internal static let forgotPasswordViewControllerIdentifier = SceneType<Bold.ForgotPasswordViewController>(storyboard: Auth.self, identifier: "ForgotPasswordViewControllerIdentifier")

    internal static let forgotSuccessViewControllerIdentifier = SceneType<Bold.ForgotSuccessViewController>(storyboard: Auth.self, identifier: "ForgotSuccessViewControllerIdentifier")
  }
  internal enum Description: StoryboardType {
    internal static let storyboardName = "Description"

    internal static let descriptionAndLikesCountViewController = SceneType<Bold.DescriptionAndLikesCountViewController>(storyboard: Description.self, identifier: "DescriptionAndLikesCountViewController")
  }
  internal enum Feel: StoryboardType {
    internal static let storyboardName = "Feel"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Feel.self)

    internal static let actionsListViewController = SceneType<Bold.ActionsListViewController>(storyboard: Feel.self, identifier: "ActionsListViewController")
  }
  internal enum Home: StoryboardType {
    internal static let storyboardName = "Home"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Home.self)
  }
  internal enum Menu: StoryboardType {
    internal static let storyboardName = "Menu"

    internal static let initialScene = InitialSceneType<Bold.HostViewController>(storyboard: Menu.self)

    internal static let leftMenuViewController = SceneType<Bold.LeftMenuViewController>(storyboard: Menu.self, identifier: "LeftMenuViewController")
  }
  internal enum Player: StoryboardType {
    internal static let storyboardName = "Player"

    internal static let initialScene = InitialSceneType<Bold.PlayerViewController>(storyboard: Player.self)
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Profile.self)
  }
  internal enum Settings: StoryboardType {
    internal static let storyboardName = "Settings"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Settings.self)

    internal static let premiumViewController = SceneType<Bold.PremiumViewController>(storyboard: Settings.self, identifier: "PremiumViewController")
  }
  internal enum Splash: StoryboardType {
    internal static let storyboardName = "Splash"

    internal static let initialScene = InitialSceneType<Bold.SplashViewController>(storyboard: Splash.self)

    internal static let onboardViewControllerIdentifier = SceneType<Bold.OnboardViewController>(storyboard: Splash.self, identifier: "OnboardViewControllerIdentifier")

    internal static let splashViewControllerIdentifier = SceneType<Bold.SplashViewController>(storyboard: Splash.self, identifier: "SplashViewControllerIdentifier")
  }
  internal enum Think: StoryboardType {
    internal static let storyboardName = "Think"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Think.self)

    internal static let citationViewController = SceneType<Bold.CitationViewController>(storyboard: Think.self, identifier: "CitationViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
