// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f6cccc"></span>
  /// Alpha: 100% <br/> (0xf6ccccff)
  internal static let ariesTopColor = ColorName(rgbaValue: 0xf6ccccff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f3f5f8"></span>
  /// Alpha: 100% <br/> (0xf3f5f8ff)
  internal static let cellEvenColor = ColorName(rgbaValue: 0xf3f5f8ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1c3aa7"></span>
  /// Alpha: 100% <br/> (0x1c3aa7ff)
  internal static let goalBlue = ColorName(rgbaValue: 0x1c3aa7ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#44b3ac"></span>
  /// Alpha: 100% <br/> (0x44b3acff)
  internal static let goalGreen = ColorName(rgbaValue: 0x44b3acff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fb9d98"></span>
  /// Alpha: 100% <br/> (0xfb9d98ff)
  internal static let goalRose = ColorName(rgbaValue: 0xfb9d98ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f3c32f"></span>
  /// Alpha: 100% <br/> (0xf3c32fff)
  internal static let goalYellow = ColorName(rgbaValue: 0xf3c32fff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#4562cd"></span>
  /// Alpha: 100% <br/> (0x4562cdff)
  internal static let primaryBlue = ColorName(rgbaValue: 0x4562cdff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffaa6e"></span>
  /// Alpha: 100% <br/> (0xffaa6eff)
  internal static let primaryOrange = ColorName(rgbaValue: 0xffaa6eff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ee6751"></span>
  /// Alpha: 100% <br/> (0xee6751ff)
  internal static let primaryRed = ColorName(rgbaValue: 0xee6751ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1c3aa7"></span>
  /// Alpha: 100% <br/> (0x1c3aa7ff)
  internal static let secondaryBlue = ColorName(rgbaValue: 0x1c3aa7ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fb9d98"></span>
  /// Alpha: 100% <br/> (0xfb9d98ff)
  internal static let secondaryPink = ColorName(rgbaValue: 0xfb9d98ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#43b3ac"></span>
  /// Alpha: 100% <br/> (0x43b3acff)
  internal static let secondaryTurquoise = ColorName(rgbaValue: 0x43b3acff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f3c32f"></span>
  /// Alpha: 100% <br/> (0xf3c32fff)
  internal static let secondaryYellow = ColorName(rgbaValue: 0xf3c32fff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f4f5f9"></span>
  /// Alpha: 100% <br/> (0xf4f5f9ff)
  internal static let tableViewBackground = ColorName(rgbaValue: 0xf4f5f9ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1b2850"></span>
  /// Alpha: 100% <br/> (0x1b2850ff)
  internal static let typographyBlack100 = ColorName(rgbaValue: 0x1b2850ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#969caf"></span>
  /// Alpha: 100% <br/> (0x969cafff)
  internal static let typographyBlack25 = ColorName(rgbaValue: 0x969cafff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#767e96"></span>
  /// Alpha: 100% <br/> (0x767e96ff)
  internal static let typographyBlack50 = ColorName(rgbaValue: 0x767e96ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#495373"></span>
  /// Alpha: 100% <br/> (0x495373ff)
  internal static let typographyBlack75 = ColorName(rgbaValue: 0x495373ff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
