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
        guard kaleidoscopeViewer.isAvailable(), kaleidoscopeViewer.canView(snapshotTestResult: testResult) else {
            assertionFailure("Test result: \(testResult) can not be open in kaleidoscope viewer")
            return
        }
        kaleidoscopeViewer.view(snapshotTestResult: testResult, using: processLauncher)
    }
    
    func swap(testResult: SnapshotTestResult) {
        
    }
}
