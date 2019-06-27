// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Off
  internal static let off = L10n.tr("Localizable", "Off")
  /// Show all
  internal static let showAll = L10n.tr("Localizable", "ShowAll")
  /// View all
  internal static let viewAll = L10n.tr("Localizable", "ViewAll")

  internal enum Authorization {
    /// Email address
    internal static let email = L10n.tr("Localizable", "Authorization.Email")
    /// Facebook
    internal static let facebook = L10n.tr("Localizable", "Authorization.Facebook")
    /// Forgot password
    internal static let forgotPassword = L10n.tr("Localizable", "Authorization.ForgotPassword")
    /// Have an Account?
    internal static let haveAnAccount = L10n.tr("Localizable", "Authorization.HaveAnAccount")
    /// Haven't an Account?
    internal static let haventAnAccount = L10n.tr("Localizable", "Authorization.HaventAnAccount")
    /// I forgot
    internal static let iForgot = L10n.tr("Localizable", "Authorization.IForgot")
    /// Log In!
    internal static let logIn = L10n.tr("Localizable", "Authorization.LogIn")
    /// Log In
    internal static let logInButton = L10n.tr("Localizable", "Authorization.LogInButton")
    /// Log In now
    internal static let logInNow = L10n.tr("Localizable", "Authorization.LogInNow")
    /// or login with
    internal static let orLoginWith = L10n.tr("Localizable", "Authorization.OrLoginWith")
    /// or sign up with
    internal static let orSignUpWith = L10n.tr("Localizable", "Authorization.OrSignUpWith")
    /// Password
    internal static let password = L10n.tr("Localizable", "Authorization.Password")
    /// Put your email below and we'll send your password
    internal static let putYourEmailBelowAndWellSendYourPassword = L10n.tr("Localizable", "Authorization.PutYourEmailBelowAndWellSendYourPassword")
    /// Send me password
    internal static let sendMePassword = L10n.tr("Localizable", "Authorization.SendMePassword")
    /// Sign Up!
    internal static let signUp = L10n.tr("Localizable", "Authorization.SignUp")
    /// Sign Up
    internal static let signUpButton = L10n.tr("Localizable", "Authorization.SignUpButton")
    /// Success!
    internal static let success = L10n.tr("Localizable", "Authorization.Success")
    /// Your password was send.
    internal static let yourPasswordWasSend = L10n.tr("Localizable", "Authorization.YourPasswordWasSend")
  }

  internal enum Feel {
    /// Add to action plan
    internal static let addToActionPlan = L10n.tr("Localizable", "Feel.AddToActionPlan")
    /// Apprentice
    internal static let apprentice = L10n.tr("Localizable", "Feel.Apprentice")
    /// Duration
    internal static let duration = L10n.tr("Localizable", "Feel.Duration")
    /// Feel Bold
    internal static let feelBold = L10n.tr("Localizable", "Feel.FeelBold")
    /// Find your confidence
    internal static let findYourConfidence = L10n.tr("Localizable", "Feel.FindYourConfidence")
    /// Goal
    internal static let goal = L10n.tr("Localizable", "Feel.Goal")
    /// Hypnosis
    internal static let hypnosis = L10n.tr("Localizable", "Feel.Hypnosis")
    /// Hack your supercomputer and change unhelpful programs running in your subconscious mind.
    internal static let hypnosisSubtitle = L10n.tr("Localizable", "Feel.HypnosisSubtitle")
    /// Meditation
    internal static let meditation = L10n.tr("Localizable", "Feel.Meditation")
    /// Tune your mind, body and soul and let them work together.
    internal static let meditationSubtitle = L10n.tr("Localizable", "Feel.MeditationSubtitle")
    /// No stake
    internal static let noStake = L10n.tr("Localizable", "Feel.NoStake")
    /// Pep-talk
    internal static let pepTalk = L10n.tr("Localizable", "Feel.Pep-talk")
    /// Change the story you are telling yourself, because everything depends on it.
    internal static let pepTalkSubtitle = L10n.tr("Localizable", "Feel.Pep-talkSubtitle")
    /// Reminder
    internal static let reminder = L10n.tr("Localizable", "Feel.Reminder")
    /// Share with friends
    internal static let shareWithFriends = L10n.tr("Localizable", "Feel.ShareWithFriends")
    /// Stake
    internal static let stake = L10n.tr("Localizable", "Feel.Stake")
  }

  internal enum Menu {
    /// Act
    internal static let act = L10n.tr("Localizable", "Menu.Act")
    /// Feel
    internal static let feel = L10n.tr("Localizable", "Menu.Feel")
    /// Home
    internal static let home = L10n.tr("Localizable", "Menu.Home")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "Menu.Settings")
    /// Think
    internal static let think = L10n.tr("Localizable", "Menu.Think")
  }

  internal enum Player {
    /// Next practices
    internal static let nextPractices = L10n.tr("Localizable", "Player.NextPractices")
  }

  internal enum Splash {
    /// Act
    internal static let act = L10n.tr("Localizable", "Splash.Act")
    /// Put your sweat where your mouth is: set and conquer your Boldest goals.
    internal static let actDescription = L10n.tr("Localizable", "Splash.ActDescription")
    /// Feel
    internal static let feel = L10n.tr("Localizable", "Splash.Feel")
    /// Conquer fear: boost confidence, resilience and more, by rewiring your subconscious mind.
    internal static let feelDescription = L10n.tr("Localizable", "Splash.FeelDescription")
    /// Find your boldness
    internal static let findYourBoldness = L10n.tr("Localizable", "Splash.FindYourBoldness")
    /// Sign Up
    internal static let signUp = L10n.tr("Localizable", "Splash.SignUp")
    /// Think
    internal static let think = L10n.tr("Localizable", "Splash.Think")
    /// Our lessons, inspiring stories and quotes will guide your thinking to a new level.
    internal static let thinkDescription = L10n.tr("Localizable", "Splash.ThinkDescription")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
