//
//  TestResultsDisplayInfosCollectorSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsDisplayInfosCollectorSpec: QuickSpec {
    override func spec() {
        var subject: TestResultsDisplayInfosCollector!
        var testResults: [SnapshotTestResult] = []
        let build1 = Build(date: Date(timeIntervalSince1970: 1497252300), applicationName: "FBSnapshotsViewer")
        let build2 = Build(date: Date(timeIntervalSince1970: 1497252100), applicationName: "AmazingWeather")
        let build3 = Build(date: Date(timeIntervalSince1970: 1497252000), applicationName: "FBSnapshotsViewer")
        
        beforeEach {
            let testResult1 = SnapshotTestResult.recorded(testName: "MainScreen basicState", referenceImagePath: "foo/bar/basic_state.png", build: build1)
            let testResult2 = SnapshotTestResult.recorded(testName: "DetailScreen basicState", referenceImagePath: "foo/bar/detail_state.png", build: build1)
            let testResult3 = SnapshotTestResult.failed(testName: "DetailScreen emptyState", referenceImagePath: "foo/bar/empty_state.png", diffImagePath: "foo/bar/diff_empty_state.png", failedImagePath: "foo/bar/failed_empty_state.png", build: build1)
            let testResult4 = SnapshotTestResult.recorded(testName: "DetailScreen errorState", referenceImagePath: "foo/bar/error_state.png", build: build1)
            let testResult5 = SnapshotTestResult.failed(testName: "MainScreen errorState", referenceImagePath: "foo/bar/error_state.png", diffImagePath: "foo/bar/diff_error_state.png", failedImagePath: "foo/bar/failed_error_state.png", build: build1)
            let testResult6 = SnapshotTestResult.failed(testName: "HomeScreen emptyState", referenceImagePath: "foo/bar/empty_state.png", diffImagePath: "foo/bar/diff_empty_state.png", failedImagePath: "foo/bar/failed_empty_state.png", build: build2)
            let testResult7 = SnapshotTestResult.recorded(testName: "HomeScreen errorState", referenceImagePath: "foo/bar/error_state.png", build: build2)
            let testResult8 = SnapshotTestResult.failed(testName: "SettingsScreen errorState", referenceImagePath: "foo/bar/error_state.png", diffImagePath: "foo/bar/diff_error_state.png", failedImagePath: "foo/bar/failed_error_state.png", build: build2)
            let testResult9 = SnapshotTestResult.recorded(testName: "MainScreen basicState", referenceImagePath: "foo/bar/basic_state.png", build: build3)
            let testResult10 = SnapshotTestResult.recorded(testName: "DetailScreen basicState", referenceImagePath: "foo/bar/detail_state.png", build: build3)
            testResults = [testResult1, testResult2, testResult3, testResult4, testResult5, testResult6, testResult7, testResult8, testResult9, testResult10]
            subject = TestResultsDisplayInfosCollector(testResults: testResults)
        }
        
        describe(".collect") {
            var collectedInfos: [TestResultsSectionDisplayInfo] = []
            
            beforeEach {
                collectedInfos = subject.collect()
            }
            
            it("collects the correct display infos") {
                expect(collectedInfos.count).to(equal(6))
                
                let section1 = collectedInfos[0]
                let exepctedSection1Title = TestResultsSectionTitleDisplayInfo(title: "FBSnapshotsViewer | MainScreen", timeAgo: "About 25 minutes ago", timeAgoDate: build1.date)
                expect(section1.itemInfos.count).to(equal(2))
                expect(section1.titleInfo).to(equal(exepctedSection1Title))
                
                let section2 = collectedInfos[1]
                expect(section2.itemInfos.count).to(equal(3))
                
                let section3 = collectedInfos[2]
                expect(section3.itemInfos.count).to(equal(1))
                
                let section4 = collectedInfos[3]
                expect(section4.itemInfos.count).to(equal(2))
                
                let section5 = collectedInfos[4]
                expect(section5.itemInfos.count).to(equal(1))
                
                let section6 = collectedInfos[5]
                expect(section6.itemInfos.count).to(equal(1))
            }
        }
    }
}
