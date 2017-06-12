//
//  TestResultsHeader.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class TestResultsHeader: NSView, NSCollectionViewSectionHeaderView {
    static let itemIdentifier = "TestResultsHeader"
    
    @IBOutlet private weak var contextLabel: NSTextField!
    @IBOutlet private weak var dateLabel: NSTextField!
    
    // MARK: - Helpers
    
    private func configureTitleLabelsColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let primaryTextColor: NSColor
        let secondaryTextColor: NSColor
        switch appleInterfaceMode {
        case .dark:
            primaryTextColor = NSColor(named: .primaryTextDarkMode)
            secondaryTextColor = NSColor(named: .secondaryTextDarkMode)
        case .light:
            primaryTextColor = NSColor(named: .primaryTextLightMode)
            secondaryTextColor = NSColor(named: .secondaryTextLightMode)
        }
        contextLabel.textColor = primaryTextColor
        dateLabel.textColor = secondaryTextColor
    }
    
    // MARK: - Interface
    
    func configure(with sectionTitleInfo: TestResultsSectionTitleDisplayInfo, appleInterfaceMode: AppleInterfaceMode = AppleInterfaceMode()) {
        contextLabel.stringValue = sectionTitleInfo.title
        dateLabel.stringValue = sectionTitleInfo.timeAgo
        configureTitleLabelsColorScheme(for: appleInterfaceMode)
    }
}
