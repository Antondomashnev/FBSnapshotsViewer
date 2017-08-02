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
    let canBeSwapped: Bool
    let testResult: SnapshotTestResult

    init(testResult: SnapshotTestResult, kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self, swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper()) {
        self.testResult = testResult
        self.canBeSwapped = swapper.canSwap(testResult)
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
        let testNameComponents = testResult.testName.replacingOccurrences(of: "__", with: " ").components(separatedBy: " ").map {
            $0.replacingOccurrences(of: "_", with: " ").stripping()
        }
        self.testContext = testNameComponents.count > 1 ? testResult.testClassName + " " + testNameComponents[0..<(testNameComponents.count - 1)].joined(separator: " ") : testResult.testClassName
        self.testName = testNameComponents[testNameComponents.count - 1]
    }
}
