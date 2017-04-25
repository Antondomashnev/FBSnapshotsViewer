//
//  TestResultDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct TestResultDisplayInfo {
    let referenceImageURL: URL
    let diffImageURL: URL?
    let failedImageURL: URL?
    let testName: String

    init( testName: String, referenceImageURL: URL, diffImageURL: URL?, failedImageURL: URL?) {
        self.referenceImageURL = referenceImageURL
        self.diffImageURL = diffImageURL
        self.failedImageURL = failedImageURL
        self.testName = testName
    }

    init(testResult: SnapshotTestResult) {
        switch testResult {
        case let .recorded(testName, referenceImagePath):
            self.testName = testName
            self.referenceImageURL = URL(fileURLWithPath: referenceImagePath)
            self.diffImageURL = nil
            self.failedImageURL = nil
        case let .failed(testName, referenceImagePath, diffImagePath, failedImagePath):
            self.testName = testName
            self.referenceImageURL = URL(fileURLWithPath: referenceImagePath)
            self.diffImageURL = URL(fileURLWithPath: diffImagePath)
            self.failedImageURL = URL(fileURLWithPath: failedImagePath)
        }
    }
}
