//
//  TestResultsHeader.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

protocol TestResultsHeaderDelegate: class, AutoMockable {
    func testResultsHeader(_ header: TestResultsHeader, swapSnapshotsButtonClicked: NSButton)
}

class TestResultsHeader: NSView, NSCollectionViewSectionHeaderView {
    static let itemIdentifier = "TestResultsHeader"
    
    weak var delegate: TestResultsHeaderDelegate?
    
    @IBOutlet private weak var contextLabel: NSTextField!
    @IBOutlet private weak var dateLabel: NSTextField!
    @IBOutlet private weak var swapSnapshotsButton: NSButton!
    
    // MARK: - Helpers
    
    private func configureTitleLabelsColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        contextLabel.textColor = Color.primaryText(for: appleInterfaceMode)
        dateLabel.textColor = Color.secondaryText(for: appleInterfaceMode)
    }
    
    // MARK: - Interface
    
    func configure(with sectionTitleInfo: TestResultsSectionTitleDisplayInfo, appleInterfaceMode: AppleInterfaceMode = AppleInterfaceMode()) {
        contextLabel.stringValue = sectionTitleInfo.title
        dateLabel.stringValue = sectionTitleInfo.timeAgo
        configureTitleLabelsColorScheme(for: appleInterfaceMode)
    }
    
    // MARK: - Actions
    
    @objc @IBAction func swapSnapshotsButtonClicked(_ sender: NSButton) {
        delegate?.testResultsHeader(self, swapSnapshotsButtonClicked: sender)
    }
}
