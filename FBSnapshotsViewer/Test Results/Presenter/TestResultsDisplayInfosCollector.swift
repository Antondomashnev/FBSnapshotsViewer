//
//  TestResultsDisplayInfoCollector.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class TestResultsDisplayInfosCollector {
    // MARK: - Helpers
    
    private func groupTestResultsByAssociatedSectionTitle(_ testResults: [SnapshotTestResult]) -> [TestResultsSectionTitleDisplayInfo: [TestResultDisplayInfo]] {
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
        return temporaryDictionary
    }
    
    private func createSectionDisplayInfos(with groupedTestResults: [TestResultsSectionTitleDisplayInfo: [TestResultDisplayInfo]]) -> [TestResultsSectionDisplayInfo] {
        return groupedTestResults.map { (key, value) -> TestResultsSectionDisplayInfo in
          return TestResultsSectionDisplayInfo(title: key, items: value)
        }.sorted { (one, two) -> Bool in
          let timeAgo1 = one.titleInfo.timeAgoDate
          let timeAgo2 = two.titleInfo.timeAgoDate
          return timeAgo1 != timeAgo2 ? timeAgo1 >= timeAgo2 : one.titleInfo.title > two.titleInfo.title
      }
    }
    
    // MARK: - Interface
    
    func collect(testResults: [SnapshotTestResult] = []) -> [TestResultsSectionDisplayInfo] {
        let goupedDictionary = groupTestResultsByAssociatedSectionTitle(testResults)
        return createSectionDisplayInfos(with: goupedDictionary)
    }
}
