//
//  TestResultsDisplayInfoCollector.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class TestResultsDisplayInfoCollector {
    private let testResults: [SnapshotTestResult]
    
    init(testResults: [SnapshotTestResult] = []) {
        self.testResults = testResults
    }
    
    // MARK: - Interface
    
    func collect() -> [TestResultsSectionDisplayInfo] {
        var temporaryDictionary: [TestResultsSectionTitleDisplayInfo: [TestResultDisplayInfo]] = [:]
        testResults.forEach {
            let testResultInfo = TestResultDisplayInfo(testResult: $0)
            let titleInfo = TestResultsSectionTitleDisplayInfo(build: $0.build, testContext: testResultInfo.testContext)
            if var testResultInfos = temporaryDictionary[titleInfo] {
                testResultInfos.append(testResultInfo)
                temporaryDictionary[titleInfo] = testResultInfos
            }
            else {
                temporaryDictionary[titleInfo] = [testResultInfo]
            }
        }
        return temporaryDictionary.map { TestResultsSectionDisplayInfo(title: $0.key, items: $0.value) }
    }
}
