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

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer?.backgroundColor = NSColor(named: .primaryLight).cgColor
        configureTitleLabelsColorScheme()
        configureSeparatorsColorScheme()
    }

    // MARK: - Helpers

    private func configureSeparatorsColorScheme() {
        referenceSeparatorView.layer?.backgroundColor = NSColor(named: .divider).cgColor
        diffSeparatorView.layer?.backgroundColor = NSColor(named: .divider).cgColor
        failedSeparatorView.layer?.backgroundColor = NSColor(named: .divider).cgColor
    }

    private func configureTitleLabelsColorScheme() {
        testNameLabel.textColor = NSColor(named: .primaryText)
        testNameLabel.layer?.backgroundColor = NSColor.clear.cgColor
        referenceImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        diffImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        failedImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        referenceImageTitleLabel.textColor = NSColor(named: .secondaryText)
        diffImageTitleLabel.textColor = NSColor(named: .secondaryText)
        failedImageTitleLabel.textColor = NSColor(named: .secondaryText)
    }

    // MARK: - Interface

    func configure(with testResult: TestResultDisplayInfo) {
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
    }
}
