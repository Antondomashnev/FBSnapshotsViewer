//
//  TestResultsInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum TestResultsInteractorError: Error {
    case canNotSwapNotExistedTestResult
}

class TestResultsInteractorBuilder {
    var kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self
    var processLauncher: ProcessLauncher = ProcessLauncher()
    var swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper()
    var testResults: [SnapshotTestResult] = []
    
    typealias BuiderClojure = (TestResultsInteractorBuilder) -> Void
    
    init(clojure: BuiderClojure) {
        clojure(self)
    }
}

class TestResultsInteractor {
    fileprivate let kaleidoscopeViewer: ExternalViewer.Type
    fileprivate let processLauncher: ProcessLauncher
    fileprivate let swapper: SnapshotTestResultSwapper
    var testResults: [SnapshotTestResult]
    
    weak var output: TestResultsInteractorOutput?

    init(builder: TestResultsInteractorBuilder) {
        self.testResults = builder.testResults
        self.kaleidoscopeViewer = builder.kaleidoscopeViewer
        self.processLauncher = builder.processLauncher
        self.swapper = builder.swapper
    }
}

extension TestResultsInteractor: TestResultsInteractorInput {
    // MARK: - Helpers
    
    private func replace(testResult: SnapshotTestResult, with newTestResult: SnapshotTestResult) throws {
        guard let indexOfTestResult = testResults.index(of: testResult) else {
            throw TestResultsInteractorError.canNotSwapNotExistedTestResult
        }
        testResults[indexOfTestResult] = newTestResult
    }
    
    // MARK: - TestResultsInteractorInput

    func openInKaleidoscope(testResult: SnapshotTestResult) {
        guard kaleidoscopeViewer.isAvailable(), kaleidoscopeViewer.canView(snapshotTestResult: testResult) else {
            assertionFailure("Test result: \(testResult) can not be open in kaleidoscope viewer")
            return
        }
        kaleidoscopeViewer.view(snapshotTestResult: testResult, using: processLauncher)
    }
    
    func swap(testResult: SnapshotTestResult) {
        if !swapper.canSwap(testResult) {
            return
        }
        do {
            let swappedTestResult = try swapper.swap(testResult)
            try replace(testResult: testResult, with: swappedTestResult)
        }
        catch let error {
            output?.didFailToSwap(testResult: testResult, with: error)
        }
    }
}
