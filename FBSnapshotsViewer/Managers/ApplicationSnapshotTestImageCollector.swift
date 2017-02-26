//
//  ApplicationSnapshotTestResultCollector.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol ApplicationSnapshotTestImageCollectorOutput: class {
    func applicationSnapshotTestResultCollector(_ collector: ApplicationSnapshotTestImageCollector, didCollect testResult: TestResult)
}

class ApplicationSnapshotTestImageCollector {
    weak var output: ApplicationSnapshotTestImageCollectorOutput?

    private var pendingTestResults: [String: PendingTestResult] = [:]
    
    // MARK: - Interface
    
    func collect(_ testImage: SnapshotTestImage) {
        let testName = testImage.testName
        var pendingTestResult: PendingTestResult = pendingTestResults[testName] ?? PendingTestResult(testName: testName)
        
        switch testImage {
        case let .diff(imagePath):
            pendingTestResult.diffImagePath = imagePath
        case let .reference(imagePath):
            pendingTestResult.referenceImagePath = imagePath
        case let .failed(imagePath):
            pendingTestResult.failedImagePath = imagePath
        }
        
        if let completedTestResult = pendingTestResult.completedTestResult {
            pendingTestResults.removeValue(forKey: testName)
            output?.applicationSnapshotTestResultCollector(self, didCollect: completedTestResult)
        }
        else {
            pendingTestResults[testName] = pendingTestResult
        }
    }
}
