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
        let build1 = Build(date: Date(timeIntervalSinceNow: -300), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
        let build2 = Build(date: Date(timeIntervalSinceNow: -500), applicationName: "AmazingWeather", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/foo", isDirectory: true)])
        let build3 = Build(date: Date(timeIntervalSinceNow: -700), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
        
        beforeEach {
            subject = TestResultsDisplayInfosCollector()
        }
        
        describe(".collect") {
            var collectedInfos: [TestResultsSectionDisplayInfo] = []
            
            beforeEach {
                let testInformation1 = SnapshotTestInformation(testClassName: "MainScreen", testName: "basicState", testFilePath: "foo/MainScreen", testLineNumber: 1)
                let testResult1 = SnapshotTestResult.recorded(testInformation: testInformation1, referenceImagePath: "foo/bar/basic_state.png", build: build1)
                let testInformation2 = SnapshotTestInformation(testClassName: "DetailScreen", testName: "basicState", testFilePath: "foo/DetailScreen", testLineNumber: 1)
                let testResult2 = SnapshotTestResult.recorded(testInformation: testInformation2, referenceImagePath: "foo/bar/detail_state.png", build: build1)
                let testInformation3 = SnapshotTestInformation(testClassName: "DetailScreen", testName: "emptyState", testFilePath: "foo/DetailScreen", testLineNumber: 2)
                let testResult3 = SnapshotTestResult.failed(testInformation: testInformation3, referenceImagePath: "foo/bar/empty_state.png", diffImagePath: "foo/bar/diff_empty_state.png", failedImagePath: "foo/bar/failed_empty_state.png", build: build1)
                let testInformation4 = SnapshotTestInformation(testClassName: "DetailScreen", testName: "errorState", testFilePath: "foo/DetailScreen", testLineNumber: 3)
                let testResult4 = SnapshotTestResult.recorded(testInformation: testInformation4, referenceImagePath: "foo/bar/error_state.png", build: build1)
                let testInformation5 = SnapshotTestInformation(testClassName: "MainScreen", testName: "errorState", testFilePath: "foo/MainScreen", testLineNumber: 2)
                let testResult5 = SnapshotTestResult.failed(testInformation: testInformation5, referenceImagePath: "foo/bar/error_state.png", diffImagePath: "foo/bar/diff_error_state.png", failedImagePath: "foo/bar/failed_error_state.png", build: build1)
                let testInformation6 = SnapshotTestInformation(testClassName: "HomeScreen", testName: "emptyState", testFilePath: "foo/HomeScreen", testLineNumber: 1)
                let testResult6 = SnapshotTestResult.failed(testInformation: testInformation6, referenceImagePath: "foo/bar/empty_state.png", diffImagePath: "foo/bar/diff_empty_state.png", failedImagePath: "foo/bar/failed_empty_state.png", build: build2)
                let testInformation7 = SnapshotTestInformation(testClassName: "HomeScreen", testName: "errorState", testFilePath: "foo/HomeScreen", testLineNumber: 2)
                let testResult7 = SnapshotTestResult.recorded(testInformation: testInformation7, referenceImagePath: "foo/bar/error_state.png", build: build2)
                let testInformation8 = SnapshotTestInformation(testClassName: "SettingsScreen", testName: "errorState", testFilePath: "foo/SettingsScreen", testLineNumber: 2)
                let testResult8 = SnapshotTestResult.failed(testInformation: testInformation8, referenceImagePath: "foo/bar/error_state.png", diffImagePath: "foo/bar/diff_error_state.png", failedImagePath: "foo/bar/failed_error_state.png", build: build2)
                let testInformation9 = SnapshotTestInformation(testClassName: "MainScreen", testName: "basicState", testFilePath: "foo/MainScreen", testLineNumber: 4)
                let testResult9 = SnapshotTestResult.recorded(testInformation: testInformation9, referenceImagePath: "foo/bar/basic_state.png", build: build3)
                let testInformation10 = SnapshotTestInformation(testClassName: "MainScreen", testName: "basicState", testFilePath: "foo/MainScreen", testLineNumber: 4)
                let testResult10 = SnapshotTestResult.recorded(testInformation: testInformation10, referenceImagePath: "foo/bar/detail_state.png", build: build3)
                testResults = [testResult1, testResult2, testResult3, testResult4, testResult5, testResult6, testResult7, testResult8, testResult9, testResult10]
                collectedInfos = subject.collect(testResults: testResults)
            }
            
            it("collects the correct display infos") {
                expect(collectedInfos.count).to(equal(6))
                
                let section1 = collectedInfos[0]
                let exepctedSection1Title = TestResultsSectionTitleDisplayInfo(title: "FBSnapshotsViewer | MainScreen", timeAgo: "About 5 minutes ago", timeAgoDate: build1.date)
                expect(section1.itemInfos.count).to(equal(2))
                expect(section1.titleInfo).to(equal(exepctedSection1Title))
                
                let section2 = collectedInfos[1]
                let exepctedSection2Title = TestResultsSectionTitleDisplayInfo(title: "FBSnapshotsViewer | DetailScreen", timeAgo: "About 5 minutes ago", timeAgoDate: build1.date)
                expect(section2.itemInfos.count).to(equal(3))
                expect(section2.titleInfo).to(equal(exepctedSection2Title))
                
                let section3 = collectedInfos[2]
                let exepctedSection3Title = TestResultsSectionTitleDisplayInfo(title: "AmazingWeather | SettingsScreen", timeAgo: "About 8 minutes ago", timeAgoDate: build2.date)
                expect(section3.itemInfos.count).to(equal(1))
                expect(section3.titleInfo).to(equal(exepctedSection3Title))
                
                let section4 = collectedInfos[3]
                let exepctedSection4Title = TestResultsSectionTitleDisplayInfo(title: "AmazingWeather | HomeScreen", timeAgo: "About 8 minutes ago", timeAgoDate: build2.date)
                expect(section4.itemInfos.count).to(equal(2))
                expect(section4.titleInfo).to(equal(exepctedSection4Title))
                
                let section5 = collectedInfos[4]
                let exepctedSection5Title = TestResultsSectionTitleDisplayInfo(title: "FBSnapshotsViewer | MainScreen", timeAgo: "About 12 minutes ago", timeAgoDate: build3.date)
                expect(section5.itemInfos.count).to(equal(1))
                expect(section5.titleInfo).to(equal(exepctedSection5Title))
                
                let section6 = collectedInfos[5]
                let exepctedSection6Title = TestResultsSectionTitleDisplayInfo(title: "FBSnapshotsViewer | DetailScreen", timeAgo: "About 12 minutes ago", timeAgoDate: build3.date)
                expect(section6.itemInfos.count).to(equal(1))
                expect(section6.titleInfo).to(equal(exepctedSection6Title))
            }
        }
    }
}
