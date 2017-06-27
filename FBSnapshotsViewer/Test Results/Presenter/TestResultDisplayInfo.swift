//
//  TestResultDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct TestResultDisplayInfo: AutoEquatable {
    let referenceImageURL: URL
    let diffImageURL: URL?
    let failedImageURL: URL?
    let testName: String
    let testContext: String
    let canBeViewedInKaleidoscope: Bool
    let testResult: SnapshotTestResult

    init(testResult: SnapshotTestResult, kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self) {
        self.testResult = testResult
        self.canBeViewedInKaleidoscope = kaleidoscopeViewer.isAvailable() && kaleidoscopeViewer.canView(snapshotTestResult: testResult)
        switch testResult {
        case let .recorded(_, referenceImagePath, _):
            self.referenceImageURL = URL(fileURLWithPath: referenceImagePath)
            self.diffImageURL = nil
            self.failedImageURL = nil
        case let .failed(_, referenceImagePath, diffImagePath, failedImagePath, _):
            self.referenceImageURL = URL(fileURLWithPath: referenceImagePath)
            self.diffImageURL = URL(fileURLWithPath: diffImagePath)
            self.failedImageURL = URL(fileURLWithPath: failedImagePath)
        }
        let testNameComponents = testResult.testName.replacingOccurrences(of: "_", with: " ").components(separatedBy: " ")
        self.testContext = testResult.testClassName + " " + testNameComponents[0..<(testNameComponents.count - 1)].joined(separator: " ")
        self.testName = testNameComponents[testNameComponents.count - 1]
    }
}
