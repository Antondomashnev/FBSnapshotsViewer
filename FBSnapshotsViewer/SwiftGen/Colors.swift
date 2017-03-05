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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bdbdbd"></span>
    /// Alpha: 100% <br/> (0xbdbdbdff)
    case divider
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cfd8dc"></span>
    /// Alpha: 100% <br/> (0xcfd8dcff)
    case primaryLight
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#212121"></span>
    /// Alpha: 86% <br/> (0x212121dd)
    case primaryText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#757575"></span>
    /// Alpha: 54% <br/> (0x7575758a)
    case secondaryText
    
    var rgbaValue: UInt32 {
        switch self {
        case .divider:
            return 0xbdbdbdff
        case .primaryLight:
            return 0xcfd8dcff
        case .primaryText:
            return 0x212121dd
        case .secondaryText:
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
