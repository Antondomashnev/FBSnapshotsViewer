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
    static let canBeCopied = TestResultDisplayInfoOptions(rawValue: 1 << 3)
}

extension TestResultDisplayInfoOptions {
    static func availableOptions(for testResult: SnapshotTestResult, externalViewers: ExternalViewers = ExternalViewers(), swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper()) -> TestResultDisplayInfoOptions {
        var availableOptions: TestResultDisplayInfoOptions = [TestResultDisplayInfoOptions.canBeCopied]
        if swapper.canSwap(testResult) { availableOptions = availableOptions.union(.canBeSwapped) }
        if externalViewers.xcode.isAvailable() && externalViewers.xcode.canView(snapshotTestResult: testResult) { availableOptions = availableOptions.union(.canBeViewedInXcode) }
        if externalViewers.kaleidoscope.isAvailable() && externalViewers.kaleidoscope.canView(snapshotTestResult: testResult) { availableOptions = availableOptions.union(.canBeViewedInKaleidoscope) }
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
    
    var canBeCopied: Bool {
        return options.contains(.canBeCopied)
    }

    init(testResult: SnapshotTestResult, swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper(), externalViewers: ExternalViewers = ExternalViewers()) {
        self.testResult = testResult
        self.testInformation = TestResultInformationDisplayInfo(testResultInformation: testResult.testInformation)
        self.options = TestResultDisplayInfoOptions.availableOptions(for: testResult, externalViewers: externalViewers, swapper: swapper)
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
