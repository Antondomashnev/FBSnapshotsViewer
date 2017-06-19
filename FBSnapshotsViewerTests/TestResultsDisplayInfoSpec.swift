//
//  TestResultsDisplayInfoSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 18.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsDisplayInfoSpec: QuickSpec {
    override func spec() {
        var displayInfo: TestResultsDisplayInfo!
        var sectionInfos: [TestResultsSectionDisplayInfo] = []
        
        describe(".init") {
            beforeEach {
                let build1 = Build(applicationName: "FBSnapshotsViewer")
                let build2 = Build(applicationName: "AmazingWeather")
                let build3 = Build(applicationName: "FBSnapshotsViewer")
                let testResultInfo1 = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "foo_name", referenceImagePath: "foo/bar.png", build: build1))
                let testResultInfo2 = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "foo_name", referenceImagePath: "foo/bar.png", build: build2))
                let testResultInfo3 = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "foo_name", referenceImagePath: "foo/bar.png", build: build3))
                let testResultInfo4 = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "foo_name", referenceImagePath: "foo/bar.png", build: build3))
                let sectionTitleInfo1 = TestResultsSectionTitleDisplayInfo(build: build1, testContext: "context1")
                let sectionInfo1 = TestResultsSectionDisplayInfo(title: sectionTitleInfo1, items: [testResultInfo1])
                let sectionTitleInfo2 = TestResultsSectionTitleDisplayInfo(build: build2, testContext: "context2")
                let sectionInfo2 = TestResultsSectionDisplayInfo(title: sectionTitleInfo2, items: [testResultInfo2])
                let sectionTitleInfo3 = TestResultsSectionTitleDisplayInfo(build: build3, testContext: "context3")
                let sectionInfo3 = TestResultsSectionDisplayInfo(title: sectionTitleInfo3, items: [testResultInfo3, testResultInfo4])
                sectionInfos = [sectionInfo1, sectionInfo2, sectionInfo3]
                displayInfo = TestResultsDisplayInfo(sectionInfos: sectionInfos, testResultsDiffMode: .mouseOver)
            }
            
            it("has correct section infos") {
                expect(displayInfo.sectionInfos).to(equal(sectionInfos))
            }
            
            context("when one test result") {
                beforeEach {
                    displayInfo = TestResultsDisplayInfo(sectionInfos: [sectionInfos[0]], testResultsDiffMode: .mouseOver)
                }
                
                it("has correct topTitle") {
                    expect(displayInfo.topTitle).to(equal("1 Test Result"))
                }
            }
            
            context("when multiple test results") {
                it("has correct topTitle") {
                    expect(displayInfo.topTitle).to(equal("4 Test Results"))
                }
            }
            
            it("has correct testResultsDiffMode") {
                expect(displayInfo.testResultsDiffMode).to(equal(TestResultsDiffMode.mouseOver))
            }
        }
    }
}
