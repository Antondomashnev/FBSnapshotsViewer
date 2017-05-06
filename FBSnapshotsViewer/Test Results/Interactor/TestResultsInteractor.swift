//
//  TestResultsInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class TestResultsInteractor {
    fileprivate let kaleidoscopeViewer: ExternalViewer.Type
    fileprivate let processLauncher: ProcessLauncher
    let testResults: [SnapshotTestResult]

    init(testResults: [SnapshotTestResult], kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self, processLauncher: ProcessLauncher = ProcessLauncher()) {
        self.testResults = testResults
        self.kaleidoscopeViewer = kaleidoscopeViewer
        self.processLauncher = processLauncher
    }
}

extension TestResultsInteractor: TestResultsInteractorInput {
    // MARK: - TestResultsInteractorInput

    func openInKaleidoscope(testResult: SnapshotTestResult) {
        kaleidoscopeViewer.view(snapshotTestResult: testResult, using: processLauncher)
    }
}
