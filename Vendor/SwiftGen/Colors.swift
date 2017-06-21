// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIColor
    typealias Color = UIColor
#elseif os(OSX)
    import AppKit.NSColor
    typealias Color = NSColor
#endif

// swiftlint:disable operator_usage_whitespace
extension Color {
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
// swiftlint:enable operator_usage_whitespace

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum ColorName {
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fafafa"></span>
    /// Alpha: 86% <br/> (0xfafafadd)
    case buttonBackgroundDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#212121"></span>
    /// Alpha: 86% <br/> (0x212121dd)
    case buttonBackgroundLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 86% <br/> (0xffffffdd)
    case buttonTitleDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 86% <br/> (0xffffffdd)
    case buttonTitleLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f5f5f5"></span>
    /// Alpha: 100% <br/> (0xf5f5f5ff)
    case dividerDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bdbdbd"></span>
    /// Alpha: 100% <br/> (0xbdbdbdff)
    case dividerLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#eceff1"></span>
    /// Alpha: 87% <br/> (0xeceff1de)
    case primaryLightDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cfd8dc"></span>
    /// Alpha: 87% <br/> (0xcfd8dcde)
    case primaryLightLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 87% <br/> (0xffffffde)
    case primaryTextDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 87% <br/> (0x000000de)
    case primaryTextLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 87% <br/> (0xffffffde)
    case secondaryTextDarkMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#757575"></span>
    /// Alpha: 87% <br/> (0x757575de)
    case secondaryTextLightMode
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d1d0d1"></span>
    /// Alpha: 100% <br/> (0xd1d0d1ff)
    case testResultsTopViewColorBottom
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e7e6e7"></span>
    /// Alpha: 100% <br/> (0xe7e6e7ff)
    case testResultsTopViewColorTop
    
    var rgbaValue: UInt32 {
        switch self {
        case .buttonBackgroundDarkMode:
            return 0xfafafadd
        case .buttonBackgroundLightMode:
            return 0x212121dd
        case .buttonTitleDarkMode:
            return 0xffffffdd
        case .buttonTitleLightMode:
            return 0xffffffdd
        case .dividerDarkMode:
            return 0xf5f5f5ff
        case .dividerLightMode:
            return 0xbdbdbdff
        case .primaryLightDarkMode:
            return 0xeceff1de
        case .primaryLightLightMode:
            return 0xcfd8dcde
        case .primaryTextDarkMode:
            return 0xffffffde
        case .primaryTextLightMode:
            return 0x000000de
        case .secondaryTextDarkMode:
            return 0xffffffde
        case .secondaryTextLightMode:
            return 0x757575de
        case .testResultsTopViewColorBottom:
            return 0xd1d0d1ff
        case .testResultsTopViewColorTop:
            return 0xe7e6e7ff
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
// swiftlint:enable file_length
// swiftlint:enable line_length
