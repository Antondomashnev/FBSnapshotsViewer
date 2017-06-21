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
        let dividerColor = Color.divider(for: appleInterfaceMode)
        separatorView.wantsLayer = true
        separatorView.layer?.backgroundColor = dividerColor.cgColor
    }

    private func configureTitleLabelsColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        testNameLabel.textColor = Color.primaryText(for: appleInterfaceMode)
        referenceImageTitleLabel.textColor = Color.secondaryText(for: appleInterfaceMode)
        failedImageTitleLabel.textColor = Color.secondaryText(for: appleInterfaceMode)
    }
    
    private func configureBordersColorScheme(for appleInterfaceMode: AppleInterfaceMode) {
        let borderColor = Color.divider(for: appleInterfaceMode)
        [failedImageView, referenceImageView, diffContainerView, splitContainerView].forEach {
            $0?.wantsLayer = true
            $0?.layer?.borderColor = borderColor.cgColor
            $0?.layer?.borderWidth = 1
        }
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
    
    private func configureUI(for appleInterfaceMode: AppleInterfaceMode) {
        configureTitleLabelsColorScheme(for: appleInterfaceMode)
        configureSeparatorsColorScheme(for: appleInterfaceMode)
        configureBordersColorScheme(for: appleInterfaceMode)
    }
    
    private func configureUI(with testResult: TestResultDisplayInfo) {
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
    }

    // MARK: - Interface

    func configure(with testResult: TestResultDisplayInfo, appleInterfaceMode: AppleInterfaceMode = AppleInterfaceMode(), diffMode: TestResultsDiffMode = .mouseOver) {
        configureUI(with: testResult)
        configureUI(for: appleInterfaceMode)
        configureUI(for: diffMode)
        splitContainerView.configure(with: testResult, appleInterfaceMode: appleInterfaceMode)
    }

    // MARK: - Actions

    @objc @IBAction func viewInKaleidoscopeButtonClicked(_ sender: NSButton) {
        delegate?.testResultCell(self, viewInKaleidoscopeButtonClicked: sender)
    }
}
