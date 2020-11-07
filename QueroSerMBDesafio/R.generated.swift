//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.accessibility` struct is generated, and contains static references to 4 localization keys.
    struct accessibility {
      /// Value: Asset Cell
      static let assetCell = Rswift.StringResource(key: "assetCell", tableName: "Accessibility", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Asset Detail
      static let assetDetail = Rswift.StringResource(key: "assetDetail", tableName: "Accessibility", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Asset List
      static let assetList = Rswift.StringResource(key: "assetList", tableName: "Accessibility", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Navigation View
      static let navigationApplicaton = Rswift.StringResource(key: "navigationApplicaton", tableName: "Accessibility", bundle: R.hostingBundle, locales: [], comment: nil)

      /// Value: Asset Cell
      static func assetCell(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("assetCell", tableName: "Accessibility", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Accessibility", preferredLanguages: preferredLanguages) else {
          return "assetCell"
        }

        return NSLocalizedString("assetCell", tableName: "Accessibility", bundle: bundle, comment: "")
      }

      /// Value: Asset Detail
      static func assetDetail(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("assetDetail", tableName: "Accessibility", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Accessibility", preferredLanguages: preferredLanguages) else {
          return "assetDetail"
        }

        return NSLocalizedString("assetDetail", tableName: "Accessibility", bundle: bundle, comment: "")
      }

      /// Value: Asset List
      static func assetList(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("assetList", tableName: "Accessibility", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Accessibility", preferredLanguages: preferredLanguages) else {
          return "assetList"
        }

        return NSLocalizedString("assetList", tableName: "Accessibility", bundle: bundle, comment: "")
      }

      /// Value: Navigation View
      static func navigationApplicaton(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("navigationApplicaton", tableName: "Accessibility", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Accessibility", preferredLanguages: preferredLanguages) else {
          return "navigationApplicaton"
        }

        return NSLocalizedString("navigationApplicaton", tableName: "Accessibility", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    /// This `R.string.app` struct is generated, and contains static references to 6 localization keys.
    struct app {
      /// en translation: An unexpected error has occurred.
      ///
      /// Locales: en, pt-BR
      static let other = Rswift.StringResource(key: "other", tableName: "App", bundle: R.hostingBundle, locales: ["en", "pt-BR"], comment: nil)
      /// en translation: An unexpected error occurred while communicating with the server.
      ///
      /// Locales: en, pt-BR
      static let mapping = Rswift.StringResource(key: "mapping", tableName: "App", bundle: R.hostingBundle, locales: ["en", "pt-BR"], comment: nil)
      /// en translation: Overview
      ///
      /// Locales: en, pt-BR
      static let homeTitle = Rswift.StringResource(key: "homeTitle", tableName: "App", bundle: R.hostingBundle, locales: ["en", "pt-BR"], comment: nil)
      /// en translation: Please try again later.
      ///
      /// Locales: en
      static let apiNotAvailable = Rswift.StringResource(key: "apiNotAvailable", tableName: "App", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: You are currently offline.
      ///
      /// Locales: en, pt-BR
      static let offline = Rswift.StringResource(key: "offline", tableName: "App", bundle: R.hostingBundle, locales: ["en", "pt-BR"], comment: nil)
      /// en translation: erro
      ///
      /// Locales: en, pt-BR
      static let error = Rswift.StringResource(key: "error", tableName: "App", bundle: R.hostingBundle, locales: ["en", "pt-BR"], comment: nil)

      /// en translation: An unexpected error has occurred.
      ///
      /// Locales: en, pt-BR
      static func other(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("other", tableName: "App", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "App", preferredLanguages: preferredLanguages) else {
          return "other"
        }

        return NSLocalizedString("other", tableName: "App", bundle: bundle, comment: "")
      }

      /// en translation: An unexpected error occurred while communicating with the server.
      ///
      /// Locales: en, pt-BR
      static func mapping(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("mapping", tableName: "App", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "App", preferredLanguages: preferredLanguages) else {
          return "mapping"
        }

        return NSLocalizedString("mapping", tableName: "App", bundle: bundle, comment: "")
      }

      /// en translation: Overview
      ///
      /// Locales: en, pt-BR
      static func homeTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("homeTitle", tableName: "App", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "App", preferredLanguages: preferredLanguages) else {
          return "homeTitle"
        }

        return NSLocalizedString("homeTitle", tableName: "App", bundle: bundle, comment: "")
      }

      /// en translation: Please try again later.
      ///
      /// Locales: en
      static func apiNotAvailable(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("apiNotAvailable", tableName: "App", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "App", preferredLanguages: preferredLanguages) else {
          return "apiNotAvailable"
        }

        return NSLocalizedString("apiNotAvailable", tableName: "App", bundle: bundle, comment: "")
      }

      /// en translation: You are currently offline.
      ///
      /// Locales: en, pt-BR
      static func offline(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("offline", tableName: "App", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "App", preferredLanguages: preferredLanguages) else {
          return "offline"
        }

        return NSLocalizedString("offline", tableName: "App", bundle: bundle, comment: "")
      }

      /// en translation: erro
      ///
      /// Locales: en, pt-BR
      static func error(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("error", tableName: "App", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "App", preferredLanguages: preferredLanguages) else {
          return "error"
        }

        return NSLocalizedString("error", tableName: "App", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
