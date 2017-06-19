//
//  TestResultCell.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

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
    
    @IBOutlet private weak var splitContainerView: TestResultSplitView!
    
    @IBOutlet private weak var diffContainerView: NSView!
    @IBOutlet private weak var diffImageView: NSImageView!
    
    @IBOutlet private weak var testInfoContainerView: NSView!
    @IBOutlet private weak var testNameLabel: NSTextField!
    
    @IBOutlet private weak var separatorView: NSView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorView.isHidden = true
    }
    
    // MARK: - Helpers

    private func configureSeparatorsColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let dividerColor: NSColor
        switch appleInterfaceMode {
        case .dark:
            dividerColor = NSColor(named: .dividerDarkMode)
        case .light:
            dividerColor = NSColor(named: .dividerLightMode)
        }
        separatorView.wantsLayer = true
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
    
    private func configureBordersColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let borderColor: NSColor
        switch appleInterfaceMode {
        case .dark:
            borderColor = NSColor(named: .dividerDarkMode)
        case .light:
            borderColor = NSColor(named: .dividerLightMode)
        }
        failedImageView.wantsLayer = true
        referenceImageView.wantsLayer = true
        diffContainerView.wantsLayer = true
        splitContainerView.wantsLayer = true
        failedImageView.layer?.borderColor = borderColor.cgColor
        referenceImageView.layer?.borderColor = borderColor.cgColor
        diffContainerView.layer?.borderColor = borderColor.cgColor
        splitContainerView.layer?.borderColor = borderColor.cgColor
        referenceImageView.layer?.borderWidth = 1
        failedImageView.layer?.borderWidth = 1
        diffContainerView.layer?.borderWidth = 1
        splitContainerView.layer?.borderWidth = 1
    }
    
    private func configureUI(for diffMode: TestResultsDiffMode) {
        switch diffMode {
        case .diff:
            splitContainerView.isHidden = true
            diffContainerView.isHidden = false
        case .mouseOver:
            diffContainerView.isHidden = true
            splitContainerView.isHidden = false
        }
    }

    // MARK: - Interface

    func configure(with testResult: TestResultDisplayInfo, appleInterfaceMode: AppleInterfaceMode = AppleInterfaceMode(), diffMode: TestResultsDiffMode = .mouseOver) {
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
        configureBordersColorScheme(for: appleInterfaceMode)
        configureUI(for: diffMode)
        splitContainerView.configure(with: testResult, appleInterfaceMode: appleInterfaceMode)
    }

    // MARK: - Actions

    @objc @IBAction func viewInKaleidoscopeButtonClicked(_ sender: NSButton) {
        delegate?.testResultCell(self, viewInKaleidoscopeButtonClicked: sender)
    }
}
