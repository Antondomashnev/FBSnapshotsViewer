//
//  TestResultsInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsInteractor: TestResultsInteractorInput {
    let testResults: [SnapshotTestResult]

    init(testResults: [SnapshotTestResult]) {
        self.testResults = testResults
    }
}
