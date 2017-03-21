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
    let diffImageURL: URL
    let failedImageURL: URL
    let testName: String

    init(referenceImageURL: URL, diffImageURL: URL, failedImageURL: URL, testName: String) {
        self.referenceImageURL = referenceImageURL
        self.diffImageURL = diffImageURL
        self.failedImageURL = failedImageURL
        self.testName = testName
    }

    init(testResult: TestResult) {
        testName = testResult.testName
        referenceImageURL = URL(fileURLWithPath: testResult.referenceImagePath)
        diffImageURL = URL(fileURLWithPath: testResult.diffImagePath)
        failedImageURL = URL(fileURLWithPath: testResult.failedImagePath)
    }
}
