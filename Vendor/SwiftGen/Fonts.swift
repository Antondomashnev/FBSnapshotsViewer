// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIFont
    typealias Font = UIFont
#elseif os(OSX)
    import AppKit.NSFont
    typealias Font = NSFont
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

protocol FontConvertible {
    func font(size: CGFloat) -> Font!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
    func font(size: CGFloat) -> Font! {
        return Font(font: self, size: size)
    }
    
    func register() {
        let extensions = ["otf", "ttf"]
        let bundle = Bundle(for: BundleToken.self)
        
        guard let url = extensions.flatMap({ bundle.url(forResource: rawValue, withExtension: $0) }).first else { return }
        
        var errorRef: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(url as CFURL, .none, &errorRef)
    }
}

extension Font {
    convenience init!<FontType: FontConvertible>
        (font: FontType, size: CGFloat)
        where FontType: RawRepresentable, FontType.RawValue == String {
            #if os(iOS) || os(tvOS) || os(watchOS)
                if UIFont.fontNames(forFamilyName: font.rawValue).isEmpty {
                    font.register()
                }
            #elseif os(OSX)
          if NSFontManager.shared.availableMembers(ofFontFamily: font.rawValue) == nil {
                    font.register()
                }
            #endif
            
            self.init(name: font.rawValue, size: size)
    }
}

enum FontFamily {
    enum AppleColorEmojiUI: String, FontConvertible {
        case regular = ".AppleColorEmojiUI"
    }
    enum AppleSDGothicNeoI: String, FontConvertible {
        case bold = ".AppleSDGothicNeoI-Bold"
        case extraBold = ".AppleSDGothicNeoI-ExtraBold"
        case heavy = ".AppleSDGothicNeoI-Heavy"
        case light = ".AppleSDGothicNeoI-Light"
        case medium = ".AppleSDGothicNeoI-Medium"
        case regular = ".AppleSDGothicNeoI-Regular"
        case semiBold = ".AppleSDGothicNeoI-SemiBold"
        case thin = ".AppleSDGothicNeoI-Thin"
        case ultraLight = ".AppleSDGothicNeoI-UltraLight"
    }
    enum AquaKana: String, FontConvertible {
        case regular = "AquaKana"
        case bold = "AquaKana-Bold"
    }
    enum ArialHebrewDeskInterface: String, FontConvertible {
        case regular = ".ArialHebrewDeskInterface"
        case bold = ".ArialHebrewDeskInterface-Bold"
        case light = ".ArialHebrewDeskInterface-Light"
    }
    enum GeezaProInterface: String, FontConvertible {
        case regular = ".GeezaProInterface"
        case bold = ".GeezaProInterface-Bold"
        case light = ".GeezaProInterface-Light"
    }
    enum GeezaProPUA: String, FontConvertible {
        case bold = ".GeezaProPUA-Bold"
        case regular = ".GeezaProPUA-Regular"
    }
    enum HelveticaNeueDeskInterface: String, FontConvertible {
        case bold = ".HelveticaNeueDeskInterface-Bold"
        case boldItalic = ".HelveticaNeueDeskInterface-BoldItalic"
        case heavy = ".HelveticaNeueDeskInterface-Heavy"
        case italic = ".HelveticaNeueDeskInterface-Italic"
        case light = ".HelveticaNeueDeskInterface-Light"
        case mediumItalic = ".HelveticaNeueDeskInterface-MediumItalicP4"
        case medium = ".HelveticaNeueDeskInterface-MediumP4"
        case regular = ".HelveticaNeueDeskInterface-Regular"
        case thin = ".HelveticaNeueDeskInterface-Thin"
        case ultraLight = ".HelveticaNeueDeskInterface-UltraLightP2"
    }
    enum HiraginoKakuGothicInterface: String, FontConvertible {
        case w0 = ".HiraKakuInterface-W0"
        case w1 = ".HiraKakuInterface-W1"
        case w2 = ".HiraKakuInterface-W2"
        case w3 = ".HiraKakuInterface-W3"
        case w4 = ".HiraKakuInterface-W4"
        case w5 = ".HiraKakuInterface-W5"
        case w6 = ".HiraKakuInterface-W6"
        case w7 = ".HiraKakuInterface-W7"
        case w8 = ".HiraKakuInterface-W8"
        case w9 = ".HiraKakuInterface-W9"
    }
    enum HiraginoSansGBInterface: String, FontConvertible {
        case w3 = ".HiraginoSansGBInterface-W3"
        case w6 = ".HiraginoSansGBInterface-W6"
    }
    enum Keyboard: String, FontConvertible {
        case regular = ".Keyboard"
    }
    enum LastResort: String, FontConvertible {
        case regular = "LastResort"
    }
    enum LucidaGrandeUI: String, FontConvertible {
        case regular = ".LucidaGrandeUI"
        case bold = ".LucidaGrandeUI-Bold"
    }
    enum SFCompactDisplay: String, FontConvertible {
        case black = ".SFCompactDisplay-Black"
        case bold = ".SFCompactDisplay-Bold"
        case heavy = ".SFCompactDisplay-Heavy"
        case light = ".SFCompactDisplay-Light"
        case medium = ".SFCompactDisplay-Medium"
        case regular = ".SFCompactDisplay-Regular"
        case semibold = ".SFCompactDisplay-Semibold"
        case thin = ".SFCompactDisplay-Thin"
        case ultralight = ".SFCompactDisplay-Ultralight"
    }
    enum SFCompactRounded: String, FontConvertible {
        case black = ".SFCompactRounded-Black"
        case bold = ".SFCompactRounded-Bold"
        case heavy = ".SFCompactRounded-Heavy"
        case light = ".SFCompactRounded-Light"
        case medium = ".SFCompactRounded-Medium"
        case regular = ".SFCompactRounded-Regular"
        case semibold = ".SFCompactRounded-Semibold"
        case thin = ".SFCompactRounded-Thin"
        case ultralight = ".SFCompactRounded-Ultralight"
    }
    enum SFCompactText: String, FontConvertible {
        case bold = ".SFCompactText-Bold"
        case boldItalic = ".SFCompactText-BoldItalic"
        case heavy = ".SFCompactText-Heavy"
        case heavyItalic = ".SFCompactText-HeavyItalic"
        case italic = ".SFCompactText-Italic"
        case light = ".SFCompactText-Light"
        case lightItalic = ".SFCompactText-LightItalic"
        case medium = ".SFCompactText-Medium"
        case mediumItalic = ".SFCompactText-MediumItalic"
        case regular = ".SFCompactText-Regular"
        case semibold = ".SFCompactText-Semibold"
        case semiboldItalic = ".SFCompactText-SemiboldItalic"
    }
    enum SFNSDisplay: String, FontConvertible {
        case regular = ".SFNSDisplay"
        case black = ".SFNSDisplay-Black"
        case bold = ".SFNSDisplay-Bold"
        case heavy = ".SFNSDisplay-Heavy"
        case light = ".SFNSDisplay-Light"
        case medium = ".SFNSDisplay-Medium"
        case semibold = ".SFNSDisplay-Semibold"
        case thin = ".SFNSDisplay-Thin"
        case ultralight = ".SFNSDisplay-Ultralight"
    }
    enum SFNSDisplayCondensed: String, FontConvertible {
        case black = ".SFNSDisplayCondensed-Black"
        case bold = ".SFNSDisplayCondensed-Bold"
        case heavy = ".SFNSDisplayCondensed-Heavy"
        case light = ".SFNSDisplayCondensed-Light"
        case medium = ".SFNSDisplayCondensed-Medium"
        case regular = ".SFNSDisplayCondensed-Regular"
        case semibold = ".SFNSDisplayCondensed-Semibold"
        case thin = ".SFNSDisplayCondensed-Thin"
        case ultralight = ".SFNSDisplayCondensed-Ultralight"
    }
    enum SFNSText: String, FontConvertible {
        case regular = ".SFNSText"
        case bold = ".SFNSText-Bold"
        case boldItalic = ".SFNSText-BoldItalic"
        case heavy = ".SFNSText-Heavy"
        case heavyItalic = ".SFNSText-HeavyItalic"
        case italic = ".SFNSText-Italic"
        case light = ".SFNSText-Light"
        case lightItalic = ".SFNSText-LightItalic"
        case medium = ".SFNSText-Medium"
        case mediumItalic = ".SFNSText-MediumItalic"
        case semibold = ".SFNSText-Semibold"
        case semiboldItalic = ".SFNSText-SemiboldItalic"
    }
    enum SFNSTextCondensed: String, FontConvertible {
        case bold = ".SFNSTextCondensed-Bold"
        case heavy = ".SFNSTextCondensed-Heavy"
        case light = ".SFNSTextCondensed-Light"
        case medium = ".SFNSTextCondensed-Medium"
        case regular = ".SFNSTextCondensed-Regular"
        case semibold = ".SFNSTextCondensed-Semibold"
    }
    enum AppleBraille: String, FontConvertible {
        case regular = "AppleBraille"
        case outline6Dot = "AppleBraille-Outline6Dot"
        case outline8Dot = "AppleBraille-Outline8Dot"
        case pinpoint6Dot = "AppleBraille-Pinpoint6Dot"
        case pinpoint8Dot = "AppleBraille-Pinpoint8Dot"
    }
    enum AppleColorEmoji: String, FontConvertible {
        case regular = "AppleColorEmoji"
    }
    enum AppleSDGothicNeo: String, FontConvertible {
        case bold = "AppleSDGothicNeo-Bold"
        case extraBold = "AppleSDGothicNeo-ExtraBold"
        case heavy = "AppleSDGothicNeo-Heavy"
        case light = "AppleSDGothicNeo-Light"
        case medium = "AppleSDGothicNeo-Medium"
        case regular = "AppleSDGothicNeo-Regular"
        case semiBold = "AppleSDGothicNeo-SemiBold"
        case thin = "AppleSDGothicNeo-Thin"
        case ultraLight = "AppleSDGothicNeo-UltraLight"
    }
    enum AppleSymbols: String, FontConvertible {
        case regular = "AppleSymbols"
    }
    enum ArialHebrew: String, FontConvertible {
        case regular = "ArialHebrew"
        case bold = "ArialHebrew-Bold"
        case light = "ArialHebrew-Light"
    }
    enum ArialHebrewScholar: String, FontConvertible {
        case regular = "ArialHebrewScholar"
        case bold = "ArialHebrewScholar-Bold"
        case light = "ArialHebrewScholar-Light"
    }
    enum Avenir: String, FontConvertible {
        case black = "Avenir-Black"
        case blackOblique = "Avenir-BlackOblique"
        case book = "Avenir-Book"
        case bookOblique = "Avenir-BookOblique"
        case heavy = "Avenir-Heavy"
        case heavyOblique = "Avenir-HeavyOblique"
        case light = "Avenir-Light"
        case lightOblique = "Avenir-LightOblique"
        case medium = "Avenir-Medium"
        case mediumOblique = "Avenir-MediumOblique"
        case oblique = "Avenir-Oblique"
        case roman = "Avenir-Roman"
    }
    enum AvenirNext: String, FontConvertible {
        case bold = "AvenirNext-Bold"
        case boldItalic = "AvenirNext-BoldItalic"
        case demiBold = "AvenirNext-DemiBold"
        case demiBoldItalic = "AvenirNext-DemiBoldItalic"
        case heavy = "AvenirNext-Heavy"
        case heavyItalic = "AvenirNext-HeavyItalic"
        case italic = "AvenirNext-Italic"
        case medium = "AvenirNext-Medium"
        case mediumItalic = "AvenirNext-MediumItalic"
        case regular = "AvenirNext-Regular"
        case ultraLight = "AvenirNext-UltraLight"
        case ultraLightItalic = "AvenirNext-UltraLightItalic"
    }
    enum AvenirNextCondensed: String, FontConvertible {
        case bold = "AvenirNextCondensed-Bold"
        case boldItalic = "AvenirNextCondensed-BoldItalic"
        case demiBold = "AvenirNextCondensed-DemiBold"
        case demiBoldItalic = "AvenirNextCondensed-DemiBoldItalic"
        case heavy = "AvenirNextCondensed-Heavy"
        case heavyItalic = "AvenirNextCondensed-HeavyItalic"
        case italic = "AvenirNextCondensed-Italic"
        case medium = "AvenirNextCondensed-Medium"
        case mediumItalic = "AvenirNextCondensed-MediumItalic"
        case regular = "AvenirNextCondensed-Regular"
        case ultraLight = "AvenirNextCondensed-UltraLight"
        case ultraLightItalic = "AvenirNextCondensed-UltraLightItalic"
    }
    enum Courier: String, FontConvertible {
        case regular = "Courier"
        case bold = "Courier-Bold"
        case boldOblique = "Courier-BoldOblique"
        case oblique = "Courier-Oblique"
    }
    enum GeezaPro: String, FontConvertible {
        case regular = "GeezaPro"
        case bold = "GeezaPro-Bold"
    }
    enum Geneva: String, FontConvertible {
        case regular = "Geneva"
    }
    enum HeitiSC: String, FontConvertible {
        case light = "STHeitiSC-Light"
        case medium = "STHeitiSC-Medium"
    }
    enum HeitiTC: String, FontConvertible {
        case light = "STHeitiTC-Light"
        case medium = "STHeitiTC-Medium"
    }
    enum Helvetica: String, FontConvertible {
        case regular = "Helvetica"
        case bold = "Helvetica-Bold"
        case boldOblique = "Helvetica-BoldOblique"
        case light = "Helvetica-Light"
        case lightOblique = "Helvetica-LightOblique"
        case oblique = "Helvetica-Oblique"
    }
    enum HelveticaNeue: String, FontConvertible {
        case regular = "HelveticaNeue"
        case bold = "HelveticaNeue-Bold"
        case boldItalic = "HelveticaNeue-BoldItalic"
        case condensedBlack = "HelveticaNeue-CondensedBlack"
        case condensedBold = "HelveticaNeue-CondensedBold"
        case italic = "HelveticaNeue-Italic"
        case light = "HelveticaNeue-Light"
        case lightItalic = "HelveticaNeue-LightItalic"
        case medium = "HelveticaNeue-Medium"
        case mediumItalic = "HelveticaNeue-MediumItalic"
        case thin = "HelveticaNeue-Thin"
        case thinItalic = "HelveticaNeue-ThinItalic"
        case ultraLight = "HelveticaNeue-UltraLight"
        case ultraLightItalic = "HelveticaNeue-UltraLightItalic"
    }
    enum HiraginoKakuGothicPro: String, FontConvertible {
        case w3 = "HiraKakuPro-W3"
        case w6 = "HiraKakuPro-W6"
    }
    enum HiraginoKakuGothicProN: String, FontConvertible {
        case w3 = "HiraKakuProN-W3"
        case w6 = "HiraKakuProN-W6"
    }
    enum HiraginoKakuGothicStd: String, FontConvertible {
        case w8 = "HiraKakuStd-W8"
    }
    enum HiraginoKakuGothicStdN: String, FontConvertible {
        case w8 = "HiraKakuStdN-W8"
    }
    enum HiraginoMinchoPro: String, FontConvertible {
        case w3 = "HiraMinPro-W3"
        case w6 = "HiraMinPro-W6"
    }
    enum HiraginoMinchoProN: String, FontConvertible {
        case w3 = "HiraMinProN-W3"
        case w6 = "HiraMinProN-W6"
    }
    enum HiraginoSans: String, FontConvertible {
        case w0 = "HiraginoSans-W0"
        case w1 = "HiraginoSans-W1"
        case w2 = "HiraginoSans-W2"
        case w3 = "HiraginoSans-W3"
        case w4 = "HiraginoSans-W4"
        case w5 = "HiraginoSans-W5"
        case w6 = "HiraginoSans-W6"
        case w7 = "HiraginoSans-W7"
        case w8 = "HiraginoSans-W8"
        case w9 = "HiraginoSans-W9"
    }
    enum HiraginoSansGB: String, FontConvertible {
        case w3 = "HiraginoSansGB-W3"
        case w6 = "HiraginoSansGB-W6"
    }
    enum KohinoorBangla: String, FontConvertible {
        case bold = "KohinoorBangla-Bold"
        case light = "KohinoorBangla-Light"
        case medium = "KohinoorBangla-Medium"
        case regular = "KohinoorBangla-Regular"
        case semibold = "KohinoorBangla-Semibold"
    }
    enum KohinoorDevanagari: String, FontConvertible {
        case bold = "KohinoorDevanagari-Bold"
        case light = "KohinoorDevanagari-Light"
        case medium = "KohinoorDevanagari-Medium"
        case regular = "KohinoorDevanagari-Regular"
        case semibold = "KohinoorDevanagari-Semibold"
    }
    enum KohinoorTelugu: String, FontConvertible {
        case bold = "KohinoorTelugu-Bold"
        case light = "KohinoorTelugu-Light"
        case medium = "KohinoorTelugu-Medium"
        case regular = "KohinoorTelugu-Regular"
        case semibold = "KohinoorTelugu-Semibold"
    }
    enum LucidaGrande: String, FontConvertible {
        case regular = "LucidaGrande"
        case bold = "LucidaGrande-Bold"
    }
    enum MarkerFelt: String, FontConvertible {
        case thin = "MarkerFelt-Thin"
        case wide = "MarkerFelt-Wide"
    }
    enum Menlo: String, FontConvertible {
        case bold = "Menlo-Bold"
        case boldItalic = "Menlo-BoldItalic"
        case italic = "Menlo-Italic"
        case regular = "Menlo-Regular"
    }
    enum Monaco: String, FontConvertible {
        case regular = "Monaco"
    }
    enum Noteworthy: String, FontConvertible {
        case bold = "Noteworthy-Bold"
        case light = "Noteworthy-Light"
    }
    enum Optima: String, FontConvertible {
        case bold = "Optima-Bold"
        case boldItalic = "Optima-BoldItalic"
        case extraBlack = "Optima-ExtraBlack"
        case italic = "Optima-Italic"
        case regular = "Optima-Regular"
    }
    enum Palatino: String, FontConvertible {
        case bold = "Palatino-Bold"
        case boldItalic = "Palatino-BoldItalic"
        case italic = "Palatino-Italic"
        case regular = "Palatino-Roman"
    }
    enum PingFangHK: String, FontConvertible {
        case light = "PingFangHK-Light"
        case medium = "PingFangHK-Medium"
        case regular = "PingFangHK-Regular"
        case semibold = "PingFangHK-Semibold"
        case thin = "PingFangHK-Thin"
        case ultralight = "PingFangHK-Ultralight"
    }
    enum PingFangSC: String, FontConvertible {
        case light = "PingFangSC-Light"
        case medium = "PingFangSC-Medium"
        case regular = "PingFangSC-Regular"
        case semibold = "PingFangSC-Semibold"
        case thin = "PingFangSC-Thin"
        case ultralight = "PingFangSC-Ultralight"
    }
    enum PingFangTC: String, FontConvertible {
        case light = "PingFangTC-Light"
        case medium = "PingFangTC-Medium"
        case regular = "PingFangTC-Regular"
        case semibold = "PingFangTC-Semibold"
        case thin = "PingFangTC-Thin"
        case ultralight = "PingFangTC-Ultralight"
    }
    enum Symbol: String, FontConvertible {
        case regular = "Symbol"
    }
    enum Thonburi: String, FontConvertible {
        case regular = "Thonburi"
        case bold = "Thonburi-Bold"
        case light = "Thonburi-Light"
    }
    enum Times: String, FontConvertible {
        case bold = "Times-Bold"
        case boldItalic = "Times-BoldItalic"
        case italic = "Times-Italic"
        case regular = "Times-Roman"
    }
    enum ZapfDingbats: String, FontConvertible {
        case regular = "ZapfDingbatsITC"
    }
}

private final class BundleToken {}
