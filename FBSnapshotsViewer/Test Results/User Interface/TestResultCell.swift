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
        self.view.layer?.backgroundColor = NSColor(named: .primaryLight).cgColor
        self.testNameLabel.textColor = NSColor(named: .primaryText)
        self.testNameLabel.layer?.backgroundColor = NSColor.clear.cgColor
        self.referenceImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        self.diffImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        self.failedImageTitleLabel.layer?.backgroundColor = NSColor.clear.cgColor
        self.referenceImageTitleLabel.textColor = NSColor(named: .secondaryText)
        self.diffImageTitleLabel.textColor = NSColor(named: .secondaryText)
        self.failedImageTitleLabel.textColor = NSColor(named: .secondaryText)
        self.referenceSeparatorView.layer?.backgroundColor = NSColor(named: .divider).cgColor
        self.diffSeparatorView.layer?.backgroundColor = NSColor(named: .divider).cgColor
        self.failedSeparatorView.layer?.backgroundColor = NSColor(named: .divider).cgColor
    }

    // MARK: - Interface

    func configure(with testResult: TestResultDisplayInfo) {
        if let referenceImage = NSImage(contentsOf: testResult.referenceImageURL) {
            referenceImageView.image = referenceImage
        }
        if let diffImage = NSImage(contentsOf: testResult.diffImageURL) {
            diffImageView.image = diffImage
        }
        if let failedImage = NSImage(contentsOf: testResult.failedImageURL) {
            failedImageView.image = failedImage
        }
        testNameLabel.stringValue = testResult.testName
    }
}
