//
//  TestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol TestResult {
    var referenceImagePath: String { get }
    var diffImagePath: String { get }
    var failedImagePath: String { get }
    var testName: String { get }
}

struct CompletedTestResult: TestResult {
    let referenceImagePath: String
    let diffImagePath: String
    let failedImagePath: String
    let testName: String
}

struct PendingTestResult: TestResult {
    var referenceImagePath: String = ""
    var diffImagePath: String = ""
    var failedImagePath: String = ""
    let testName: String
    
    init(testName: String) {
        self.testName = testName
    }
}
