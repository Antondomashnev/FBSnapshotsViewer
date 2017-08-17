//
//  TestResultDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct TestResultInformationDisplayInfo: AutoEquatable {
    let testName: String
    let testContext: String
    
    init(testResultInformation: SnapshotTestInformation) {
        let testNameComponents = testResultInformation.testName.replacingOccurrences(of: "__", with: " ").components(separatedBy: " ").map {
            $0.replacingOccurrences(of: "_", with: " ").stripping()
        }
        self.testContext = testNameComponents.count > 1 ? testResultInformation.testClassName + " " + testNameComponents[0..<(testNameComponents.count - 1)].joined(separator: " ") : testResultInformation.testClassName
        self.testName = testNameComponents[testNameComponents.count - 1]
    }
}

struct TestResultDisplayInfoOptions: OptionSet {
    let rawValue: Int
    static let canBeSwapped = TestResultDisplayInfoOptions(rawValue: 1 << 0)
    static let canBeViewedInKaleidoscope = TestResultDisplayInfoOptions(rawValue: 1 << 1)
    static let canBeViewedInXcode = TestResultDisplayInfoOptions(rawValue: 1 << 2)
}

extension TestResultDisplayInfoOptions {
    static func availableOptions(for testResult: SnapshotTestResult, kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self, swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper(), xcodeViewer: ExternalViewer.Type = XcodeViewer.self) -> TestResultDisplayInfoOptions {
        var availableOptions: TestResultDisplayInfoOptions = []
        if swapper.canSwap(testResult) { availableOptions = availableOptions.union(.canBeSwapped) }
        if xcodeViewer.isAvailable() && xcodeViewer.canView(snapshotTestResult: testResult) { availableOptions = availableOptions.union(.canBeViewedInXcode) }
        if kaleidoscopeViewer.isAvailable() && kaleidoscopeViewer.canView(snapshotTestResult: testResult) { availableOptions = availableOptions.union(.canBeViewedInKaleidoscope) }
        return availableOptions
    }
}

struct TestResultDisplayInfo: AutoEquatable {
    let referenceImageURL: URL
    let diffImageURL: URL?
    let failedImageURL: URL?
    let options: TestResultDisplayInfoOptions
    let testInformation: TestResultInformationDisplayInfo
    let testResult: SnapshotTestResult

    var testName: String {
        return testInformation.testName
    }

    var testContext: String {
        return testInformation.testContext
    }
    
    var canBeSwapped: Bool {
        return options.contains(.canBeSwapped)
    }
    
    var canBeViewedInKaleidoscope: Bool {
        return options.contains(.canBeViewedInKaleidoscope)
    }
    
    var canBeViewedInXcode: Bool {
        return options.contains(.canBeViewedInXcode)
    }

    init(testResult: SnapshotTestResult, kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self, swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper(), xcodeViewer: ExternalViewer.Type = XcodeViewer.self) {
        self.testResult = testResult
        self.testInformation = TestResultInformationDisplayInfo(testResultInformation: testResult.testInformation)
        self.options = TestResultDisplayInfoOptions.availableOptions(for: testResult, kaleidoscopeViewer: kaleidoscopeViewer, swapper: swapper, xcodeViewer: xcodeViewer)
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
        
    }
}
