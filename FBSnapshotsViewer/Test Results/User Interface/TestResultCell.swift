//
//  TestResultCell.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol TestResultCellDelegate: class, AutoMockable {
    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton)
}

class TestResultCell: NSCollectionViewItem {
    static let itemIdentifier = "TestResultCell"

    weak var delegate: TestResultCellDelegate?
    
    @IBOutlet private weak var actionsContainerView: NSView!
    @IBOutlet private weak var viewInKaleidoscopeButton: NSButton!
    
    @IBOutlet private weak var imagesContainerView: NSView!
    @IBOutlet private weak var failedImageView: NSImageView!
    @IBOutlet private weak var referenceImageView: NSImageView!
    @IBOutlet private weak var referenceImageTitleLabel: NSTextField!
    @IBOutlet private weak var failedImageTitleLabel: NSTextField!
    
    @IBOutlet private weak var diffContainerView: NSView!
    @IBOutlet private weak var diffImageView: NSImageView!
    
    @IBOutlet private weak var testInfoContainerView: NSView!
    @IBOutlet private weak var testNameLabel: NSTextField!
    
    @IBOutlet private weak var separatorView: NSView!

    // MARK: - Helpers

    private func configureViewsBackgroundColor(for appleInterfaceMode: AppleInterfaceMode) {}

    private func configureSeparatorsColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let dividerColor: NSColor
        switch appleInterfaceMode {
        case .dark:
            dividerColor = NSColor(named: .dividerDarkMode)
        case .light:
            dividerColor = NSColor(named: .dividerLightMode)
        }
        separatorView.layer?.backgroundColor = dividerColor.cgColor
    }

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
        testNameLabel.textColor = primaryTextColor
        referenceImageTitleLabel.textColor = secondaryTextColor
        failedImageTitleLabel.textColor = secondaryTextColor
    }

    // MARK: - Interface

    func configure(with testResult: TestResultDisplayInfo, appleInterfaceMode: AppleInterfaceMode = AppleInterfaceMode()) {
        if let referenceImage = NSImage(contentsOf: testResult.referenceImageURL) {
            referenceImageView.image = referenceImage
        }
        if let diffImageURL = testResult.diffImageURL, let diffImage = NSImage(contentsOf: diffImageURL) {
            diffImageView.image = diffImage
        }
        if let failedImageURL = testResult.failedImageURL, let failedImage = NSImage(contentsOf: failedImageURL) {
            failedImageView.image = failedImage
        }
        viewInKaleidoscopeButton.isHidden = !testResult.canBeViewedInKaleidoscope
        testNameLabel.stringValue = testResult.testName
        configureTitleLabelsColorScheme(for: appleInterfaceMode)
        configureSeparatorsColorScheme(for: appleInterfaceMode)
        configureViewsBackgroundColor(for: appleInterfaceMode)
    }

    // MARK: - Actions

    @objc @IBAction func viewInKaleidoscopeButtonClicked(_ sender: NSButton) {
        delegate?.testResultCell(self, viewInKaleidoscopeButtonClicked: sender)
    }
}
