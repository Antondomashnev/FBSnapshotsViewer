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
    @IBOutlet private weak var referenceImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var referenceImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var diffImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var diffImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var failedImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var failedImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var testNameLabel: NSTextField!
    
    // MARK: - Interface
    
    func configure(with testResult: TestResult) {
        //TODO
    }
}
