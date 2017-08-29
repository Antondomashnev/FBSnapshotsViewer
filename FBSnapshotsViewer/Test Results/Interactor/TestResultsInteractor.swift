//
//  TestResultsInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import Cocoa

enum TestResultsInteractorError: Error {
    case canNotSwapNotExistedTestResult
}

class TestResultsInteractorBuilder {
    var externalViewers: ExternalViewers = ExternalViewers()
    var processLauncher: ProcessLauncher = ProcessLauncher()
    var swapper: SnapshotTestResultSwapper = SnapshotTestResultSwapper()
    var pasteboard: Pasteboard = NSPasteboard.general()
    var testResults: [SnapshotTestResult] = []
    
    typealias BuiderClojure = (TestResultsInteractorBuilder) -> Void
    
    init(clojure: BuiderClojure) {
        clojure(self)
    }
}

class TestResultsInteractor {
    fileprivate let xcodeViewer: ExternalViewer.Type
    fileprivate let kaleidoscopeViewer: ExternalViewer.Type
    fileprivate let processLauncher: ProcessLauncher
    fileprivate let swapper: SnapshotTestResultSwapper
    fileprivate let pasteboard: Pasteboard
    var testResults: [SnapshotTestResult]
    
    weak var output: TestResultsInteractorOutput?

    init(builder: TestResultsInteractorBuilder) {
        self.testResults = builder.testResults
        self.kaleidoscopeViewer = builder.externalViewers.kaleidoscope
        self.xcodeViewer = builder.externalViewers.xcode
        self.processLauncher = builder.processLauncher
        self.swapper = builder.swapper
        self.pasteboard = builder.pasteboard
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
    
    func openInXcode(testResult: SnapshotTestResult) {
        guard xcodeViewer.isAvailable(), xcodeViewer.canView(snapshotTestResult: testResult) else {
            assertionFailure("Test result: \(testResult) can not be open in xcode viewer")
            return
        }
        xcodeViewer.view(snapshotTestResult: testResult, using: processLauncher)
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
    
    func copy(testResult: SnapshotTestResult) {
        var url: URL
        switch testResult {
        case let .failed(_, _, _, failedImagePath, _):
            url = URL(fileURLWithPath: failedImagePath)
        case let .recorded(_, referenceImagePath, _):
            url = URL(fileURLWithPath: referenceImagePath)
        }
        pasteboard.copyImage(at: url)
    }
}
