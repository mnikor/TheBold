// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let actionAdd = ImageAsset(name: "actionAdd")
  internal static let actionBackground = ImageAsset(name: "actionBackground")
  internal static let actionClock = ImageAsset(name: "actionClock")
  internal static let actionDownload = ImageAsset(name: "actionDownload")
  internal static let actionDownloaded = ImageAsset(name: "actionDownloaded")
  internal static let actionImage = ImageAsset(name: "actionImage")
  internal static let actionInfo = ImageAsset(name: "actionInfo")
  internal static let actionLike = ImageAsset(name: "actionLike")
  internal static let actionLiked = ImageAsset(name: "actionLiked")
  internal static let actionLock = ImageAsset(name: "actionLock")
  internal static let actionUnlock = ImageAsset(name: "actionUnlock")
  internal static let actionUnlockBackground = ImageAsset(name: "actionUnlockBackground")
  internal static let actionUnlockIcon = ImageAsset(name: "actionUnlockIcon")
  internal static let musicBackground = ImageAsset(name: "musicBackground")
  internal static let addActionPlus = ImageAsset(name: "AddActionPlus")
  internal static let addActionShape = ImageAsset(name: "AddActionShape")
  internal static let accessoryIcon = ImageAsset(name: "accessoryIcon")
  internal static let addActionDuration = ImageAsset(name: "addActionDuration")
  internal static let addActionGoal = ImageAsset(name: "addActionGoal")
  internal static let addActionHeader = ImageAsset(name: "addActionHeader")
  internal static let addActionReminder = ImageAsset(name: "addActionReminder")
  internal static let addActionShare = ImageAsset(name: "addActionShare")
  internal static let addActionStake = ImageAsset(name: "addActionStake")
  internal static let editDisableIcon = ImageAsset(name: "editDisableIcon")
  internal static let editEnableIcon = ImageAsset(name: "editEnableIcon")
  internal static let homeHeader2Bacground = ImageAsset(name: "homeHeader2Bacground")
  internal static let homeHeaderBackground = ImageAsset(name: "homeHeaderBackground")
  internal static let homeHeaderShape = ImageAsset(name: "homeHeaderShape")
  internal static let aaIcon = ImageAsset(name: "aaIcon")
  internal static let addIcon = ImageAsset(name: "addIcon")
  internal static let closeWhite = ImageAsset(name: "closeWhite")
  internal static let downloadIcon = ImageAsset(name: "downloadIcon")
  internal static let likeIcon = ImageAsset(name: "likeIcon")
  internal static let manifestBody = ImageAsset(name: "manifestBody")
  internal static let playButtonIcon = ImageAsset(name: "playButtonIcon")
  internal static let menuAct = ImageAsset(name: "menuAct")
  internal static let menuFeel = ImageAsset(name: "menuFeel")
  internal static let menuHome = ImageAsset(name: "menuHome")
  internal static let menuIcon = ImageAsset(name: "menuIcon")
  internal static let menuSettings = ImageAsset(name: "menuSettings")
  internal static let menuThink = ImageAsset(name: "menuThink")
  internal static let menuUser = ImageAsset(name: "menuUser")
  internal static let arrowSwipe = ImageAsset(name: "arrowSwipe")
  internal static let playerBackground = ImageAsset(name: "playerBackground")
  internal static let playerDownloadIcon = ImageAsset(name: "playerDownloadIcon")
  internal static let playerDownloadedIcon = ImageAsset(name: "playerDownloadedIcon")
  internal static let playerFullScreen = ImageAsset(name: "playerFullScreen")
  internal static let playerLikeIcon = ImageAsset(name: "playerLikeIcon")
  internal static let playerLikedIcon = ImageAsset(name: "playerLikedIcon")
  internal static let playerListIcon = ImageAsset(name: "playerListIcon")
  internal static let playerNext = ImageAsset(name: "playerNext")
  internal static let playerPause = ImageAsset(name: "playerPause")
  internal static let playerPlayList = ImageAsset(name: "playerPlayList")
  internal static let playerPlusIcon = ImageAsset(name: "playerPlusIcon")
  internal static let playerPrevious = ImageAsset(name: "playerPrevious")
  internal static let playerSmallClose = ImageAsset(name: "playerSmallClose")
  internal static let playerSmallImage = ImageAsset(name: "playerSmallImage")
  internal static let playerSmallPause = ImageAsset(name: "playerSmallPause")
  internal static let test = ImageAsset(name: "test")
  internal static let actionShape = ImageAsset(name: "actionShape")
  internal static let arrowBack = ImageAsset(name: "arrowBack")
  internal static let calendarBlueIcon = ImageAsset(name: "calendarBlueIcon")
  internal static let citationBackground = ImageAsset(name: "citationBackground")
  internal static let facebook = ImageAsset(name: "facebook")
  internal static let feelBackground = ImageAsset(name: "feelBackground")
  internal static let feelShape = ImageAsset(name: "feelShape")
  internal static let inactiveActBackground = ImageAsset(name: "inactiveActBackground")
  internal static let infoIcon = ImageAsset(name: "infoIcon")
  internal static let leonardo = ImageAsset(name: "leonardo")
  internal static let logoSmall = ImageAsset(name: "logoSmall")
  internal static let menuBlueIcon = ImageAsset(name: "menuBlueIcon")
  internal static let navTemp = ImageAsset(name: "navTemp")
  internal static let passwordEye = ImageAsset(name: "passwordEye")
  internal static let plusIcon = ImageAsset(name: "plusIcon")
  internal static let rightArrowIcon = ImageAsset(name: "rightArrowIcon")
  internal static let rightArrowWhite = ImageAsset(name: "rightArrowWhite")
  internal static let screen = ImageAsset(name: "screen")
  internal static let splashBackground = ImageAsset(name: "splashBackground")
  internal static let successKey = ImageAsset(name: "successKey")
  internal static let unlockButtonIcon = ImageAsset(name: "unlockButtonIcon")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
