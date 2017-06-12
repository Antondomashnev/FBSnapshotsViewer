//
//  TestResultsDisplayInfoCollector.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class TestResultsDisplayInfosCollector {
    // MARK: - Interface
    
    func collect(testResults: [SnapshotTestResult] = []) -> [TestResultsSectionDisplayInfo] {
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
        return temporaryDictionary.map { TestResultsSectionDisplayInfo(title: $0.key, items: $0.value) }.sorted {
            let timeAgo1 = $0.0.titleInfo.timeAgoDate
            let timeAgo2 = $0.1.titleInfo.timeAgoDate
            if timeAgo1 != timeAgo2 {
                return timeAgo1 > timeAgo2
            }
            else {
                return $0.0.titleInfo.title > $0.1.titleInfo.title
            }
        }
    }
}
