// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Montserrat {
    internal static let bold = FontConvertible(name: "Montserrat-Bold", family: "Montserrat", path: "Montserrat-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "Montserrat-BoldItalic", family: "Montserrat", path: "Montserrat-BoldItalic.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-Italic", family: "Montserrat", path: "Montserrat-Italic.ttf")
    internal static let regular = FontConvertible(name: "Montserrat-Regular", family: "Montserrat", path: "Montserrat-Regular.ttf")
    internal static let all: [FontConvertible] = [bold, boldItalic, italic, regular]
  }
  internal enum MontserratBlack {
    internal static let regular = FontConvertible(name: "Montserrat-Black", family: "Montserrat Black", path: "Montserrat-Black.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-BlackItalic", family: "Montserrat Black", path: "Montserrat-BlackItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal enum MontserratExtraBold {
    internal static let regular = FontConvertible(name: "Montserrat-ExtraBold", family: "Montserrat ExtraBold", path: "Montserrat-ExtraBold.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-ExtraBoldItalic", family: "Montserrat ExtraBold", path: "Montserrat-ExtraBoldItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal enum MontserratExtraLight {
    internal static let regular = FontConvertible(name: "Montserrat-ExtraLight", family: "Montserrat ExtraLight", path: "Montserrat-ExtraLight.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-ExtraLightItalic", family: "Montserrat ExtraLight", path: "Montserrat-ExtraLightItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal enum MontserratLight {
    internal static let regular = FontConvertible(name: "Montserrat-Light", family: "Montserrat Light", path: "Montserrat-Light.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-LightItalic", family: "Montserrat Light", path: "Montserrat-LightItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal enum MontserratMedium {
    internal static let regular = FontConvertible(name: "Montserrat-Medium", family: "Montserrat Medium", path: "Montserrat-Medium.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-MediumItalic", family: "Montserrat Medium", path: "Montserrat-MediumItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal enum MontserratSemiBold {
    internal static let regular = FontConvertible(name: "Montserrat-SemiBold", family: "Montserrat SemiBold", path: "Montserrat-SemiBold.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-SemiBoldItalic", family: "Montserrat SemiBold", path: "Montserrat-SemiBoldItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal enum MontserratThin {
    internal static let regular = FontConvertible(name: "Montserrat-Thin", family: "Montserrat Thin", path: "Montserrat-Thin.ttf")
    internal static let italic = FontConvertible(name: "Montserrat-ThinItalic", family: "Montserrat Thin", path: "Montserrat-ThinItalic.ttf")
    internal static let all: [FontConvertible] = [regular, italic]
  }
  internal static let allCustomFonts: [FontConvertible] = [Montserrat.all, MontserratBlack.all, MontserratExtraBold.all, MontserratExtraLight.all, MontserratLight.all, MontserratMedium.all, MontserratSemiBold.all, MontserratThin.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = Bundle(for: BundleToken.self)
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

private final class BundleToken {}
