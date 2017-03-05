//
//  TestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol TestResult: CustomStringConvertible, CustomDebugStringConvertible {
    var referenceImagePath: String { get }
    var diffImagePath: String { get }
    var failedImagePath: String { get }
    var testName: String { get }
}

extension TestResult {
    var description: String {
        return "testName: \(testName)\nreferenceImagePath: \(referenceImagePath),\ndiffImagePath \(diffImagePath),\nfailedImagePath: \(failedImagePath)"
    }
}

extension TestResult {
    var debugDescription: String {
        return "testName: \(testName):\nreferenceImagePath: \(referenceImagePath),\ndiffImagePath \(diffImagePath),\nfailedImagePath: \(failedImagePath)"
    }
}

//*******************************************//

struct CompletedTestResult: TestResult {
    let referenceImagePath: String
    let diffImagePath: String
    let failedImagePath: String
    let testName: String
}

//*******************************************//

struct PendingTestResult: TestResult {
    var referenceImagePath: String = ""
    var diffImagePath: String = ""
    var failedImagePath: String = ""
    let testName: String

    init(testName: String) {
        self.testName = testName
    }

    var isCompleted: Bool {
        return !referenceImagePath.characters.isEmpty &&
               !diffImagePath.characters.isEmpty &&
               !failedImagePath.characters.isEmpty
    }

    var completedTestResult: CompletedTestResult? {
        if !self.isCompleted {
            return nil
        }
        return CompletedTestResult(referenceImagePath: referenceImagePath, diffImagePath: diffImagePath, failedImagePath: failedImagePath, testName: testName)
    }
}
