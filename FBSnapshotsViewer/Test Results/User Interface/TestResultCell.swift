//
//  TestResultCell.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultCell: NSCollectionViewItem {
    static let itemIdentifier = "TestResultCell"

    @IBOutlet private weak var referenceImageView: NSImageView!
    @IBOutlet private weak var diffImageView: NSImageView!
    @IBOutlet private weak var failedImageView: NSImageView!
    @IBOutlet private weak var testNameLabel: NSTextField!
    @IBOutlet private weak var referenceImageTitleLabel: NSTextField!
    @IBOutlet private weak var diffImageTitleLabel: NSTextField!
    @IBOutlet private weak var failedImageTitleLabel: NSTextField!
    @IBOutlet private weak var referenceSeparatorView: NSView!
    @IBOutlet private weak var diffSeparatorView: NSView!
    @IBOutlet private weak var failedSeparatorView: NSView!

    // MARK: - Helpers

    private func configureViewBackgroundColor(for appleInterfaceMode: AppleInterfaceMode) {
        switch appleInterfaceMode {
        case .dark:
            view.layer?.backgroundColor = NSColor(named: .primaryLightDarkMode).cgColor
        case .light:
            view.layer?.backgroundColor = NSColor(named: .primaryLightLightMode).cgColor
        }
    }

    private func configureSeparatorsColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let dividerColor: NSColor
        switch appleInterfaceMode {
        case .dark:
            dividerColor = NSColor(named: .dividerDarkMode)
        case .light:
            dividerColor = NSColor(named: .dividerLightMode)
        }
        referenceSeparatorView.layer?.backgroundColor = dividerColor.cgColor
        diffSeparatorView.layer?.backgroundColor = dividerColor.cgColor
        failedSeparatorView.layer?.backgroundColor = dividerColor.cgColor
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
        diffImageTitleLabel.textColor = secondaryTextColor
        failedImageTitleLabel.textColor = secondaryTextColor
    }

    private func configureTitleLabelsBackgroundColorScheme() {
        testNameLabel.layer?.backgroundColor = NSColor.clear.cgColor
        referenceImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        diffImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        failedImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
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
        testNameLabel.stringValue = testResult.testName
        configureTitleLabelsColorScheme(for: appleInterfaceMode)
        configureSeparatorsColorScheme(for: appleInterfaceMode)
        configureViewBackgroundColor(for: appleInterfaceMode)
    }
}
