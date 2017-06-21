//
//  Colors+AppleInterfaceMode.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 21.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

extension Color {
    static func divider(for appleInterfaceMode: AppleInterfaceMode) -> Color {
        switch appleInterfaceMode {
        case .dark:
            return Color(named: .dividerDarkMode)
        case .light:
            return Color(named: .dividerLightMode)
        }
    }
    
    static func primaryText(for appleInterfaceMode: AppleInterfaceMode) -> Color {
        switch appleInterfaceMode {
        case .dark:
            return Color(named: .primaryTextDarkMode)
        case .light:
            return Color(named: .primaryTextLightMode)
        }
    }
    
    static func secondaryText(for appleInterfaceMode: AppleInterfaceMode) -> Color {
        switch appleInterfaceMode {
        case .dark:
            return Color(named: .secondaryTextDarkMode)
        case .light:
            return Color(named: .secondaryTextLightMode)
        }
    }
}
