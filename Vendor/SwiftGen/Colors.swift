// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIColor
    typealias Color = UIColor
#elseif os(OSX)
    import AppKit.NSColor
    typealias Color = NSColor
#endif

extension Color {
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum ColorName {
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f5f5f5"></span>
    /// Alpha: 100% <br/> (0xf5f5f5ff)
    case dividerDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bdbdbd"></span>
    /// Alpha: 100% <br/> (0xbdbdbdff)
    case dividerLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#eceff1"></span>
    /// Alpha: 100% <br/> (0xeceff1ff)
    case primaryLightDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cfd8dc"></span>
    /// Alpha: 100% <br/> (0xcfd8dcff)
    case primaryLightLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 86% <br/> (0xffffffdd)
    case primaryTextDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#212121"></span>
    /// Alpha: 86% <br/> (0x212121dd)
    case primaryTextLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 54% <br/> (0xffffff8a)
    case secondaryTextDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#757575"></span>
    /// Alpha: 54% <br/> (0x7575758a)
    case secondaryTextLightMode
    
    var rgbaValue: UInt32 {
        switch self {
        case .dividerDarkMode:
            return 0xf5f5f5ff
        case .dividerLightMode:
            return 0xbdbdbdff
        case .primaryLightDarkMode:
            return 0xeceff1ff
        case .primaryLightLightMode:
            return 0xcfd8dcff
        case .primaryTextDarkMode:
            return 0xffffffdd
        case .primaryTextLightMode:
            return 0x212121dd
        case .secondaryTextDarkMode:
            return 0xffffff8a
        case .secondaryTextLightMode:
            return 0x7575758a
        }
    }
    
    var color: Color {
        return Color(named: self)
    }
}
// swiftlint:enable type_body_length

extension Color {
    convenience init(named name: ColorName) {
        self.init(rgbaValue: name.rgbaValue)
    }
}
