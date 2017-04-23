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
}

protocol MenuInteractorOutput: class, AutoMockable {
    /// Callback that notifies that new test results are found
    ///
    /// - Parameter testResult: found test result
    func didFind(new testResult: TestResult)
}
