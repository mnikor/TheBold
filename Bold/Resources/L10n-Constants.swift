// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Achieved
  internal static let achieved = L10n.tr("Localizable", "Achieved")
  /// Add to plan
  internal static let addToPlan = L10n.tr("Localizable", "AddToPlan")
  /// All
  internal static let all = L10n.tr("Localizable", "All")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "Delete")
  /// Done
  internal static let done = L10n.tr("Localizable", "Done")
  /// Get
  internal static let `get` = L10n.tr("Localizable", "Get")
  /// Listen preview
  internal static let listenPreview = L10n.tr("Localizable", "ListenPreview")
  /// No
  internal static let no = L10n.tr("Localizable", "No")
  /// Off
  internal static let off = L10n.tr("Localizable", "Off")
  /// Okay
  internal static let okay = L10n.tr("Localizable", "Okay")
  /// On
  internal static let on = L10n.tr("Localizable", "On")
  /// Read preview
  internal static let readPreview = L10n.tr("Localizable", "ReadPreview")
  /// Save
  internal static let save = L10n.tr("Localizable", "Save")
  /// Show all
  internal static let showAll = L10n.tr("Localizable", "ShowAll")
  /// Start
  internal static let start = L10n.tr("Localizable", "Start")
  /// Unlock
  internal static let unlock = L10n.tr("Localizable", "Unlock")
  /// View all
  internal static let viewAll = L10n.tr("Localizable", "ViewAll")
  /// Yes
  internal static let yes = L10n.tr("Localizable", "Yes")

  internal enum Act {
    /// Act Bold
    internal static let actBold = L10n.tr("Localizable", "Act.ActBold")
    /// Action Plan
    internal static let actionPlan = L10n.tr("Localizable", "Act.ActionPlan")
    /// Active goals
    internal static let activeGoals = L10n.tr("Localizable", "Act.ActiveGoals")
    /// Add to action plan
    internal static let addToActionPlan = L10n.tr("Localizable", "Act.AddToActionPlan")
    /// All goals
    internal static let allGoals = L10n.tr("Localizable", "Act.AllGoals")
    /// Color
    internal static let color = L10n.tr("Localizable", "Act.Color")
    /// Due on
    internal static let dueOn = L10n.tr("Localizable", "Act.DueOn")
    /// Duration
    internal static let duration = L10n.tr("Localizable", "Act.Duration")
    /// Ends
    internal static let ends = L10n.tr("Localizable", "Act.Ends")
    /// Find your confidence
    internal static let findYourConfidence = L10n.tr("Localizable", "Act.FindYourConfidence")
    /// Goal
    internal static let goal = L10n.tr("Localizable", "Act.Goal")
    /// Goal is locked
    internal static let goalIsLocked = L10n.tr("Localizable", "Act.GoalIsLocked")
    /// Goals
    internal static let goals = L10n.tr("Localizable", "Act.Goals")
    /// Hopefully, you're buzzing with nerves or excitement... Awesome. Now figure out what actions will achieve your goal.
    internal static let hopefully = L10n.tr("Localizable", "Act.Hopefully")
    /// Hopefully, you're buzzing with nerves or excitement... Awesome. Now figure out what actions will achieve your goal.
    internal static let hopefullyEmptyText = L10n.tr("Localizable", "Act.HopefullyEmptyText")
    /// Icons
    internal static let icons = L10n.tr("Localizable", "Act.Icons")
    /// Ideas
    internal static let ideas = L10n.tr("Localizable", "Act.Ideas")
    /// Missed!
    internal static let missed = L10n.tr("Localizable", "Act.Missed")
    /// No stake
    internal static let noStake = L10n.tr("Localizable", "Act.NoStake")
    /// Reminder
    internal static let reminder = L10n.tr("Localizable", "Act.Reminder")
    /// Reminders
    internal static let reminders = L10n.tr("Localizable", "Act.Reminders")
    /// Seriously no actions?
    internal static let seriouslyNoActions = L10n.tr("Localizable", "Act.SeriouslyNoActions")
    /// Share with friends
    internal static let shareWithFriends = L10n.tr("Localizable", "Act.ShareWithFriends")
    /// Stake
    internal static let stake = L10n.tr("Localizable", "Act.Stake")
    /// Stake — %@
    internal static func stakeDollar(_ p1: String) -> String {
      return L10n.tr("Localizable", "Act.StakeDollar", p1)
    }
    /// Starts
    internal static let starts = L10n.tr("Localizable", "Act.Starts")
    /// %@ of %@ completed
    internal static func toCompleted(_ p1: String, _ p2: String) -> String {
      return L10n.tr("Localizable", "Act.toCompleted", p1, p2)
    }
    /// Today’s Actions
    internal static let todaysActions = L10n.tr("Localizable", "Act.TodaysActions")
    /// When
    internal static let when = L10n.tr("Localizable", "Act.When")
    /// You have %@ action(s) with stakes
    internal static func youHaveActionWithStakes(_ p1: String) -> String {
      return L10n.tr("Localizable", "Act.YouHaveActionWithStakes", p1)
    }
    /// You have 3 tasks with stakes
    internal static let youHaveTasksWithStakes = L10n.tr("Localizable", "Act.YouHaveTasksWithStakes")
    internal enum Cell {
      /// As we progress we become different
      internal static let asWeProgressWeBecomeDifferent = L10n.tr("Localizable", "Act.Cell.AsWeProgressWeBecomeDifferent")
      /// Create goal
      internal static let createGoal = L10n.tr("Localizable", "Act.Cell.CreateGoal")
    }
    internal enum Create {
      /// What action will achieve your goal?
      internal static let actionHeader = L10n.tr("Localizable", "Act.Create.ActionHeader")
      /// Create an action
      internal static let actionTitle = L10n.tr("Localizable", "Act.Create.ActionTitle")
      /// What is your goal?
      internal static let goalHeader = L10n.tr("Localizable", "Act.Create.GoalHeader")
      /// Create a goal
      internal static let goalTitle = L10n.tr("Localizable", "Act.Create.GoalTitle")
    }
    internal enum Date {
      /// Choose date
      internal static let chooseDate = L10n.tr("Localizable", "Act.Date.Choose date")
      /// Choose end date
      internal static let chooseEndDate = L10n.tr("Localizable", "Act.Date.ChooseEndDate")
      /// Choose start date
      internal static let chooseStartDate = L10n.tr("Localizable", "Act.Date.ChooseStartDate")
    }
    internal enum Duration {
      /// After one week
      internal static let afterOneWeek = L10n.tr("Localizable", "Act.Duration.AfterOneWeek")
      /// Choose date
      internal static let chooseDate = L10n.tr("Localizable", "Act.Duration.ChooseDate")
      /// Days of week
      internal static let daysOfWeek = L10n.tr("Localizable", "Act.Duration.DaysOfWeek")
      /// Target date
      internal static let endDate = L10n.tr("Localizable", "Act.Duration.EndDate")
      /// Every day
      internal static let everyDay = L10n.tr("Localizable", "Act.Duration.EveryDay")
      /// No repeat
      internal static let noRepeat = L10n.tr("Localizable", "Act.Duration.NoRepeat")
      /// Repeat
      internal static let `repeat` = L10n.tr("Localizable", "Act.Duration.Repeat")
      /// Start date
      internal static let startDate = L10n.tr("Localizable", "Act.Duration.StartDate")
      /// Today
      internal static let today = L10n.tr("Localizable", "Act.Duration.Today")
      /// Tomorrow
      internal static let tommorow = L10n.tr("Localizable", "Act.Duration.Tommorow")
      internal enum Day {
        /// FR
        internal static let fr = L10n.tr("Localizable", "Act.Duration.Day.Fr")
        /// MO
        internal static let mo = L10n.tr("Localizable", "Act.Duration.Day.Mo")
        /// SA
        internal static let sa = L10n.tr("Localizable", "Act.Duration.Day.Sa")
        /// SU
        internal static let su = L10n.tr("Localizable", "Act.Duration.Day.Su")
        /// TH
        internal static let th = L10n.tr("Localizable", "Act.Duration.Day.Th")
        /// TU
        internal static let tu = L10n.tr("Localizable", "Act.Duration.Day.Tu")
        /// WE
        internal static let we = L10n.tr("Localizable", "Act.Duration.Day.We")
      }
    }
    internal enum Goals {
      /// Choose goal
      internal static let chooseGoal = L10n.tr("Localizable", "Act.Goals.ChooseGoal")
      /// Enter your goal
      internal static let enterYourGoal = L10n.tr("Localizable", "Act.Goals.EnterYourGoal")
      /// Or create new
      internal static let orCreateNew = L10n.tr("Localizable", "Act.Goals.OrCreateNew")
    }
    internal enum Ideas {
      /// Charity project
      internal static let charityProject = L10n.tr("Localizable", "Act.Ideas.CharityProject")
      /// Compete to win
      internal static let competeToWin = L10n.tr("Localizable", "Act.Ideas.CompeteToWin")
      /// Find a new job
      internal static let findNewJob = L10n.tr("Localizable", "Act.Ideas.FindNewJob")
      /// 10xIncome
      internal static let income = L10n.tr("Localizable", "Act.Ideas.Income")
      /// Invent something
      internal static let inventSomething = L10n.tr("Localizable", "Act.Ideas.InventSomething")
      /// Kill a project
      internal static let killProject = L10n.tr("Localizable", "Act.Ideas.KillProject")
      /// Launch start-up
      internal static let launchStartUp = L10n.tr("Localizable", "Act.Ideas.LaunchStartUp")
      /// Make discovery
      internal static let makeDiscovery = L10n.tr("Localizable", "Act.Ideas.MakeDiscovery")
      /// Marathon
      internal static let marathon = L10n.tr("Localizable", "Act.Ideas.Marathon")
      /// MasterSkill
      internal static let masterSkill = L10n.tr("Localizable", "Act.Ideas.MasterSkill")
      /// Public speech
      internal static let publicSpeech = L10n.tr("Localizable", "Act.Ideas.PublicSpeech")
      /// Quit smoking
      internal static let quitSmoking = L10n.tr("Localizable", "Act.Ideas.QuitSmoking")
      /// Sky-diving
      internal static let skyDiving = L10n.tr("Localizable", "Act.Ideas.SkyDiving")
      /// Start new project
      internal static let startNewProject = L10n.tr("Localizable", "Act.Ideas.StartNewProject")
      /// Triathlon
      internal static let triathlon = L10n.tr("Localizable", "Act.Ideas.Triathlon")
      /// Write a book
      internal static let writeBook = L10n.tr("Localizable", "Act.Ideas.WriteBook")
    }
    internal enum Reminders {
      /// Before the day
      internal static let beforeTheDay = L10n.tr("Localizable", "Act.Reminders.BeforeTheDay")
      /// No reminders
      internal static let noReminders = L10n.tr("Localizable", "Act.Reminders.NoReminders")
      /// On the day
      internal static let onTheDay = L10n.tr("Localizable", "Act.Reminders.OnTheDay")
      /// Remind me
      internal static let remindMe = L10n.tr("Localizable", "Act.Reminders.RemindMe")
      /// Set time
      internal static let setTime = L10n.tr("Localizable", "Act.Reminders.SetTime")
      /// When
      internal static let when = L10n.tr("Localizable", "Act.Reminders.When")
    }
    internal enum Share {
      /// Facebook
      internal static let facebook = L10n.tr("Localizable", "Act.Share.Facebook")
      /// My action is
      internal static let myActionIs = L10n.tr("Localizable", "Act.Share.MyActionIs")
      /// Send Email
      internal static let sendEmail = L10n.tr("Localizable", "Act.Share.SendEmail")
      /// Share
      internal static let share = L10n.tr("Localizable", "Act.Share.Share")
      /// Share with friends
      internal static let shareWithFriends = L10n.tr("Localizable", "Act.Share.ShareWithFriends")
    }
    internal enum Stake {
      /// If you miss to complete the action your goal will be locked. To unlock Stake have to be paid
      internal static let allFundsGoesToGlobalCharityFoundation = L10n.tr("Localizable", "Act.Stake.AllFundsGoesToGlobalCharityFoundation")
      /// Confirm stake
      internal static let confirmStake = L10n.tr("Localizable", "Act.Stake.ConfirmStake")
      /// gcf-care.org
      internal static let gcfCareOrg = L10n.tr("Localizable", "Act.Stake.gcfCareOrg")
      /// Have a skin in the game…
      internal static let letsMakeYourChallenging = L10n.tr("Localizable", "Act.Stake.LetsMakeYourChallenging")
      /// Your stake
      internal static let yourStake = L10n.tr("Localizable", "Act.Stake.YourStake")
    }
  }

  internal enum Alert {
    /// Are you sure you want to delete this stake?\n\nConfirm deletion
    internal static let areYouSureYouWantToDeleteThisStake = L10n.tr("Localizable", "Alert.AreYouSureYouWantToDeleteThisStake")
    /// Congratulations!
    internal static let congratulations = L10n.tr("Localizable", "Alert.Congratulations")
    /// You have completed your action, saved your stake and earned points. Keep crushing your action plan!!!
    internal static let congratulationsText1 = L10n.tr("Localizable", "Alert.CongratulationsText1")
    ///  You have completed your action and earned points. Keep crushing your action plan!!!
    internal static let congratulationsText2 = L10n.tr("Localizable", "Alert.CongratulationsText2")
    /// Don’t give up!
    internal static let dontGiveUp = L10n.tr("Localizable", "Alert.DontGiveUp")
    /// Don’t give up, keep going!
    internal static let dontGiveUpKeepGoing = L10n.tr("Localizable", "Alert.DontGiveUpKeepGoing")
    /// Fantastic! You have achieved your goal. \nCongratulations, you get additional points!!!
    internal static let goalFantastic = L10n.tr("Localizable", "Alert.GoalFantastic")
    /// A goal is achieved!
    internal static let goalIsAchieved = L10n.tr("Localizable", "Alert.GoalIsAchieved")
    /// You just made an important decision. \nKeep going, it’s an exciting journey.
    internal static let importantDecision = L10n.tr("Localizable", "Alert.ImportantDecision")
    /// Sometimes actions become irrelevant as we adapt our strategy!\n\nConfirm deletion
    internal static let sometimesActionsBecomeIrrelevantAsWeAdaptOurStrategy = L10n.tr("Localizable", "Alert.SometimesActionsBecomeIrrelevantAsWeAdaptOurStrategy")
    /// Sometimes goals become irrelevant!\n\nConfirm deletion
    internal static let sometimesGoalsBecomeIrrelevant = L10n.tr("Localizable", "Alert.SometimesGoalsBecomeIrrelevant")
    /// Sometimes it's hard to follow your plans, but on the other side is glory...\n\nSo, are you sure you want to delete this task?
    internal static let sometimesItsHardToFollowYourPlansDeleteThisTask = L10n.tr("Localizable", "Alert.SometimesItsHardToFollowYourPlansDeleteThisTask")
    /// Sometimes it's hard to follow your plans, but on the other side is glory...\n\nSo, are you sure you want to move to a later date?
    internal static let sometimesItsHardToFollowYourPlansLaterDate = L10n.tr("Localizable", "Alert.SometimesItsHardToFollowYourPlansLaterDate")
    /// Your goal is locked now.To unlock it stake should be paid with In-App Purchases. Don’t give up, keep going!
    internal static let yourGoalIsLockedNow = L10n.tr("Localizable", "Alert.YourGoalIsLockedNow")
    /// You've missed your action.
    internal static let youveMissedYourAction = L10n.tr("Localizable", "Alert.YouveMissedYourAction.")
  }

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
    /// Privacy Policy
    internal static let privacyPolicy = L10n.tr("Localizable", "Authorization.PrivacyPolicy")
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
    /// Terms
    internal static let terms = L10n.tr("Localizable", "Authorization.Terms")
    /// I agree with Terms and Privacy Policy
    internal static let termsAndPrivacy = L10n.tr("Localizable", "Authorization.TermsAndPrivacy")
    /// Your password was send.
    internal static let yourPasswordWasSend = L10n.tr("Localizable", "Authorization.YourPasswordWasSend")
  }

  internal enum Feel {
    /// Apprentice
    internal static let apprentice = L10n.tr("Localizable", "Feel.Apprentice")
    /// Feel Bold
    internal static let feelBold = L10n.tr("Localizable", "Feel.FeelBold")
    /// Hypnosis
    internal static let hypnosis = L10n.tr("Localizable", "Feel.Hypnosis")
    /// Go deep to your subconscious mind to change unhelpful programs and install new one that will help you to succeed.
    internal static let hypnosisSubtitle = L10n.tr("Localizable", "Feel.HypnosisSubtitle")
    /// Meditation
    internal static let meditation = L10n.tr("Localizable", "Feel.Meditation")
    /// Find space in your mind to find calm and clarity. Connect to your inner wisdom and power.
    internal static let meditationSubtitle = L10n.tr("Localizable", "Feel.MeditationSubtitle")
    /// Pep-talk
    internal static let pepTalk = L10n.tr("Localizable", "Feel.Pep-talk")
    /// Change the story you are telling yourself, because everything depends on it.
    internal static let pepTalkSubtitle = L10n.tr("Localizable", "Feel.Pep-talkSubtitle")
  }

  internal enum Home {
    /// And get access to all resources
    internal static let andGetAccessToAllResources = L10n.tr("Localizable", "Home.AndGetAccessToAllResources")
    /// Bold Manifest
    internal static let boldManifest = L10n.tr("Localizable", "Home.BoldManifest")
    /// Find Out
    internal static let findOut = L10n.tr("Localizable", "Home.FindOut")
    /// Find out what it means to be bold
    internal static let findOutWhatItMeansToBeBold = L10n.tr("Localizable", "Home.FindOutWhatItMeansToBeBold")
    /// Unlock
    internal static let unlock = L10n.tr("Localizable", "Home.Unlock")
    /// Unlock Premium
    internal static let unlockPremium = L10n.tr("Localizable", "Home.UnlockPremium")
  }

  internal enum InfoService {
    /// Long tap to edit selected goal
    internal static let longTapToEditSelectedGoal = L10n.tr("Localizable", "InfoService.LongTapToEditSelectedGoal")
    /// Long tap to view selected content
    internal static let longTapToViewSelectedContent = L10n.tr("Localizable", "InfoService.LongTapToViewSelectedContent")
    /// Tap to view task details
    internal static let tapToViewTaskDetails = L10n.tr("Localizable", "InfoService.TapToViewTaskDetails")
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

  internal enum Notification {
    /// Be aware of your thoughts and feelings. Alter them when needed.
    internal static let notification1 = L10n.tr("Localizable", "Notification.Notification1")
    /// Be the pilot, not the passenger 🛩
    internal static let notification10 = L10n.tr("Localizable", "Notification.Notification10")
    /// Just get better 1u{0025} every day. Compound your growth.
    internal static let notification11 = L10n.tr("Localizable", "Notification.Notification11")
    /// Speak less, do more
    internal static let notification12 = L10n.tr("Localizable", "Notification.Notification12")
    /// Seek truth, not pleasant lies
    internal static let notification13 = L10n.tr("Localizable", "Notification.Notification13")
    /// Enjoy the process. Play.Pause.Play. Repeat the cycle.
    internal static let notification14 = L10n.tr("Localizable", "Notification.Notification14")
    /// Do what is necessary, not what is pleasant
    internal static let notification15 = L10n.tr("Localizable", "Notification.Notification15")
    /// Think beyond yourself  and your ego but first take care of yourself.
    internal static let notification16 = L10n.tr("Localizable", "Notification.Notification16")
    /// Feel, Think and Act based on your future-self.
    internal static let notification2 = L10n.tr("Localizable", "Notification.Notification2")
    /// Do something meaningful today. Could be small but meaningful.
    internal static let notification3 = L10n.tr("Localizable", "Notification.Notification3")
    /// 🧘‍♀️Stay still, stay even and keep going.
    internal static let notification4 = L10n.tr("Localizable", "Notification.Notification4.")
    /// Have macro patience and move with micro speed but consistently
    internal static let notification5 = L10n.tr("Localizable", "Notification.Notification5")
    /// Don’t believe or reject things without evidence or experiment
    internal static let notification6 = L10n.tr("Localizable", "Notification.Notification6")
    /// Work on the high leverage tasks. The one that will have most impact.
    internal static let notification7 = L10n.tr("Localizable", "Notification.Notification7")
    /// Stay curious, stay humble and keep  figuring out
    internal static let notification8 = L10n.tr("Localizable", "Notification.Notification8")
    /// Create value, give more, expect less
    internal static let notification9 = L10n.tr("Localizable", "Notification.Notification9")
  }

  internal enum Player {
    /// Sessions
    internal static let nextPractices = L10n.tr("Localizable", "Player.NextPractices")
  }

  internal enum Profile {
    /// Account details
    internal static let accountDetails = L10n.tr("Localizable", "Profile.AccountDetails")
    /// Archived goals
    internal static let archivedGoals = L10n.tr("Localizable", "Profile.ArchivedGoals")
    /// Calendar & History
    internal static let calendarAndHistory = L10n.tr("Localizable", "Profile.CalendarAndHistory")
    /// Downloads
    internal static let downloads = L10n.tr("Localizable", "Profile.Downloads")
    /// Level of mastery
    internal static let levelOfMastery = L10n.tr("Localizable", "Profile.LevelOfMastery")
    /// Review
    internal static let review = L10n.tr("Localizable", "Profile.Review")
    internal enum ArchivedGoals {
      /// Completed
      internal static let completed = L10n.tr("Localizable", "Profile.ArchivedGoals.Completed")
      /// Failed
      internal static let failed = L10n.tr("Localizable", "Profile.ArchivedGoals.Failed")
    }
    internal enum LevelOfMastery {
      /// Apprentice
      internal static let apprentice = L10n.tr("Localizable", "Profile.LevelOfMastery.Apprentice")
      /// Intermidiate
      internal static let intermidiate = L10n.tr("Localizable", "Profile.LevelOfMastery.Intermidiate")
      /// Long-term goals — duration more than 10 months
      internal static let longTermGoalsDuration = L10n.tr("Localizable", "Profile.LevelOfMastery.LongTermGoalsDuration")
      /// Mid-term goals — duration 3 to 6 months
      internal static let midTermGoalsDuration = L10n.tr("Localizable", "Profile.LevelOfMastery.MidTermGoalsDuration")
      /// %d points
      internal static func points(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Profile.LevelOfMastery.Points", p1)
      }
      ///  of 500 points
      internal static let pointsOfPoints = L10n.tr("Localizable", "Profile.LevelOfMastery.PointsOfPoints")
      /// Rising power
      internal static let risingPower = L10n.tr("Localizable", "Profile.LevelOfMastery.RisingPower")
      /// Seasoned
      internal static let seasoned = L10n.tr("Localizable", "Profile.LevelOfMastery.Seasoned")
      /// Unstoppable
      internal static let unstoppable = L10n.tr("Localizable", "Profile.LevelOfMastery.Unstoppable")
      internal enum Intermidiate {
        /// 3 mid-term goals
        internal static let midTermGoals = L10n.tr("Localizable", "Profile.LevelOfMastery.Intermidiate.MidTermGoals")
      }
      internal enum RisingPower {
        /// 1 mid-term goal achieved
        internal static let midTermGoalAchieved = L10n.tr("Localizable", "Profile.LevelOfMastery.RisingPower.MidTermGoalAchieved")
      }
      internal enum Seasoned {
        /// 1 long-term and 5 mid-term achieved. Or 2 long-term goals achieved
        internal static let longTermAndMidTermAchievedOrLongTermGoalsAchieved = L10n.tr("Localizable", "Profile.LevelOfMastery.Seasoned.LongTermAndMidTermAchievedOrLongTermGoalsAchieved")
        /// Min %d points
        internal static func minPoints(_ p1: Int) -> String {
          return L10n.tr("Localizable", "Profile.LevelOfMastery.Seasoned.MinPoints", p1)
        }
      }
      internal enum Unstoppable {
        /// 3 long-term and 1 long-term goals achieved and 7 mid-term achieved
        internal static let longTermAndLongTermGoalsAchievedAndMidTermAchieved = L10n.tr("Localizable", "Profile.LevelOfMastery.Unstoppable.LongTermAndLongTermGoalsAchievedAndMidTermAchieved")
      }
    }
    internal enum Review {
      /// Description (Optional)
      internal static let descriptionOptional = L10n.tr("Localizable", "Profile.Review.DescriptionOptional")
      /// Send
      internal static let send = L10n.tr("Localizable", "Profile.Review.Send")
      /// Tap a star to rate it
      internal static let tapStarToRateIt = L10n.tr("Localizable", "Profile.Review.TapStarToRateIt")
      /// Title
      internal static let title = L10n.tr("Localizable", "Profile.Review.Title")
    }
  }

  internal enum Reminder {
    /// You have an action due to be completed tomorrow %@
    internal static func oneDayBeforeDueDate(_ p1: String) -> String {
      return L10n.tr("Localizable", "Reminder.OneDayBeforeDueDate", p1)
    }
    /// You have an action due to be completed today %@ 
    internal static func onTheDueDate(_ p1: String) -> String {
      return L10n.tr("Localizable", "Reminder.OnTheDueDate", p1)
    }
    /// \nWith a stake of %@ \nMake sure to complete it to win your stake!
    internal static func onTheDueDateAndStake(_ p1: String) -> String {
      return L10n.tr("Localizable", "Reminder.OnTheDueDateAndStake", p1)
    }
  }

  internal enum Settings {
    /// Google Calendar
    internal static let googleCalendar = L10n.tr("Localizable", "Settings.GoogleCalendar")
    /// Goals and progress in iCloud
    internal static let inCloud = L10n.tr("Localizable", "Settings.InCloud")
    /// iOS Calendar
    internal static let iosCalendar = L10n.tr("Localizable", "Settings.iOSCalendar")
    /// Offline
    internal static let offline = L10n.tr("Localizable", "Settings.Offline")
    /// Download only on Wi-Fi
    internal static let onWIFI = L10n.tr("Localizable", "Settings.OnWIFI")
    /// Premium Account
    internal static let premiumAccount = L10n.tr("Localizable", "Settings.PremiumAccount")
    /// Privacy Policy
    internal static let privacy = L10n.tr("Localizable", "Settings.Privacy")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "Settings.Settings")
    /// Sign Out
    internal static let signOut = L10n.tr("Localizable", "Settings.SignOut")
    /// Support
    internal static let support = L10n.tr("Localizable", "Settings.Support")
    /// Synchronize
    internal static let synchronise = L10n.tr("Localizable", "Settings.Synchronise")
    /// Terms & Conditions
    internal static let terms = L10n.tr("Localizable", "Settings.Terms")
    /// App version 1.1.1
    internal static let version = L10n.tr("Localizable", "Settings.Version")
  }

  internal enum Splash {
    /// Act
    internal static let act = L10n.tr("Localizable", "Splash.Act")
    /// Put your sweat where your mouth is: set and conquer your Boldest goals.
    internal static let actDescription = L10n.tr("Localizable", "Splash.ActDescription")
    /// Feel
    internal static let feel = L10n.tr("Localizable", "Splash.Feel")
    /// Conquer fear, boost confidence, resilience and more, by rewiring your subconscious mind.
    internal static let feelDescription = L10n.tr("Localizable", "Splash.FeelDescription")
    /// Find your boldness
    internal static let findYourBoldness = L10n.tr("Localizable", "Splash.FindYourBoldness")
    /// Sign Up
    internal static let signUp = L10n.tr("Localizable", "Splash.SignUp")
    /// Have faith in yourself
    internal static let text0 = L10n.tr("Localizable", "Splash.text0")
    /// Explore uncharted territories
    internal static let text1 = L10n.tr("Localizable", "Splash.text1")
    /// Keep your fire burning
    internal static let text10 = L10n.tr("Localizable", "Splash.text10")
    /// Solve bigger problems
    internal static let text11 = L10n.tr("Localizable", "Splash.text11")
    /// Attached to nothing, open to everything
    internal static let text2 = L10n.tr("Localizable", "Splash.text2")
    /// Make waves, move mountains
    internal static let text3 = L10n.tr("Localizable", "Splash.text3")
    /// Challenge your limits
    internal static let text4 = L10n.tr("Localizable", "Splash.text4")
    /// You are work in progress
    internal static let text5 = L10n.tr("Localizable", "Splash.text5")
    /// Make progress, no excuses
    internal static let text6 = L10n.tr("Localizable", "Splash.text6")
    /// Don’t say, "Why me?" Say, "Try me."
    internal static let text7 = L10n.tr("Localizable", "Splash.text7")
    /// The art of possible
    internal static let text8 = L10n.tr("Localizable", "Splash.text8")
    /// Discipline your mind
    internal static let text9 = L10n.tr("Localizable", "Splash.text9")
    /// Think
    internal static let think = L10n.tr("Localizable", "Splash.Think")
    /// Our lessons, inspiring stories and quotes will guide your thinking to a new level.
    internal static let thinkDescription = L10n.tr("Localizable", "Splash.ThinkDescription")
  }

  internal enum Think {
    /// Lessons
    internal static let lessons = L10n.tr("Localizable", "Think.Lessons")
    /// Acquire powerful knowledge to learn how to progress towards your goals.
    internal static let lessonsSubtitle = L10n.tr("Localizable", "Think.LessonsSubtitle")
    /// Stories
    internal static let stories = L10n.tr("Localizable", "Think.Stories")
    /// Inspiring stories of real Bold people: hear and learn from their insights.
    internal static let storiesSubtitle = L10n.tr("Localizable", "Think.StoriesSubtitle")
    /// Think Bold
    internal static let thinkBold = L10n.tr("Localizable", "Think.ThinkBold")
    /// Thoughts
    internal static let thoughts = L10n.tr("Localizable", "Think.Thoughts")
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
