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
