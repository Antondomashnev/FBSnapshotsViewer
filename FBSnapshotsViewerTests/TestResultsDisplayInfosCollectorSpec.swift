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
        let build1 = Build(date: Date(timeIntervalSinceNow: -300), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
        let build2 = Build(date: Date(timeIntervalSinceNow: -500), applicationName: "AmazingWeather", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/foo", isDirectory: true))
        let build3 = Build(date: Date(timeIntervalSinceNow: -700), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
        
        beforeEach {
            subject = TestResultsDisplayInfosCollector()
        }
        
        describe(".collect") {
            var collectedInfos: [TestResultsSectionDisplayInfo] = []
            
            beforeEach {
                
                let testResult1 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "MainScreen", testName: "basicState"), referenceImagePath: "foo/bar/basic_state.png", build: build1)
                let testResult2 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "DetailScreen", testName: "basicState"), referenceImagePath: "foo/bar/detail_state.png", build: build1)
                let testResult3 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "DetailScreen", testName: "emptyState"), referenceImagePath: "foo/bar/empty_state.png", diffImagePath: "foo/bar/diff_empty_state.png", failedImagePath: "foo/bar/failed_empty_state.png", build: build1)
                let testResult4 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "DetailScreen", testName: "errorState"), referenceImagePath: "foo/bar/error_state.png", build: build1)
                let testResult5 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "MainScreen", testName: "errorState"), referenceImagePath: "foo/bar/error_state.png", diffImagePath: "foo/bar/diff_error_state.png", failedImagePath: "foo/bar/failed_error_state.png", build: build1)
                let testResult6 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "HomeScreen", testName: "emptyState"), referenceImagePath: "foo/bar/empty_state.png", diffImagePath: "foo/bar/diff_empty_state.png", failedImagePath: "foo/bar/failed_empty_state.png", build: build2)
                let testResult7 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "HomeScreen", testName: "errorState"), referenceImagePath: "foo/bar/error_state.png", build: build2)
                let testResult8 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "SettingsScreen", testName: "errorState"), referenceImagePath: "foo/bar/error_state.png", diffImagePath: "foo/bar/diff_error_state.png", failedImagePath: "foo/bar/failed_error_state.png", build: build2)
                let testResult9 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "MainScreen", testName: "basicState"), referenceImagePath: "foo/bar/basic_state.png", build: build3)
                let testResult10 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "DetailScreen", testName: "basicState"), referenceImagePath: "foo/bar/detail_state.png", build: build3)
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
