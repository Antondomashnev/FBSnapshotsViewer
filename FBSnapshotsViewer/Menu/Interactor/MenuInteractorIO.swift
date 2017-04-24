//
//  MenuInteractorOutput.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuInteractorInput: class, AutoMockable {
    /// Cached test results per one application run
    var foundTestResults: [TestResult] { get }

    /// Start listening for xcode builds real-time
    ///
    /// - Parameter xcodeDerivedDataFolder: xcode derived data folder
    func startXcodeBuildsListening(xcodeDerivedDataFolder: XcodeDerivedDataFolder)

    /// Start listening for the given test's log file updates to extract
    /// stnapshot test results from it
    ///
    /// - Parameter path: build's log file absolute path
    func startSnapshotTestResultListening(fromLogFileAt path: String)
}

protocol MenuInteractorOutput: class, AutoMockable {
    /// Callback that notifies that new test results are found
    ///
    /// - Parameter testResult: found test result
    func didFindNewTestResult(_ testResult: TestResult)

    /// Callback that notifies that new Xcode test's log file is found
    ///
    /// - Parameter path: absolute log file path
    func didFindNewTestLogFile(at path: String)
}
