//
//  MenuInteractorOutput.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuInteractorInput: class {
    /// Cached test results per one application run
    var foundTestResults: [TestResult] { get }
}

protocol MenuInteractorOutput: class {
    /// Callback that notifies that new test results are found
    ///
    /// - Parameter testResult: found test result
    func didFind(new testResult: TestResult)
}

