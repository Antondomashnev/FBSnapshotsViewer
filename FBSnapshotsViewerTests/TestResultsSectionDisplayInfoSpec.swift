//
//  TestResultsSectionDisplayInfoSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsSectionDisplayInfoSpec: QuickSpec {
    override func spec() {
        var displayInfo: TestResultsSectionDisplayInfo!
        
        describe(".init") {
            var items: [TestResultDisplayInfo] = []
            var title: TestResultsSectionTitleDisplayInfo!
            
            beforeEach {
                let build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                let testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "testName", testFilePath: "foo/testClassName.m", testLineNumber: 1)
                let testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo/bar.png", build: build)
                title = TestResultsSectionTitleDisplayInfo(build: build, testContext: "TestContext")
                items = [TestResultDisplayInfo(testResult: testResult)]
                displayInfo = TestResultsSectionDisplayInfo(title: title, items: items)
            }
            
            it("initializes all properties") {
                expect(displayInfo.itemInfos).to(equal(items))
                expect(displayInfo.titleInfo).to(equal(title))
            }
        }
        
        describe(".hasItemsToAccept") {
            var build: Build!
            var items: [TestResultDisplayInfo] = []
            var title: TestResultsSectionTitleDisplayInfo!
            var testInformation: SnapshotTestInformation!
            
            beforeEach {
                testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "testName", testFilePath: "foo/testClassName.m", testLineNumber: 1)
                build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                title = TestResultsSectionTitleDisplayInfo(build: build, testContext: "TestContext")
            }
            
            context("when there is display info that can be accepted") {
                beforeEach {
                    let testResult1 = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo1/foo1.png", build: build)
                    let testResult2 = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "foo/bar.png", diffImagePath: "foo/foo.png", failedImagePath: "bar/bar.png", build: build)
                    let testResult3 = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo1/foo3.png", build: build)
                    items = [TestResultDisplayInfo(testResult: testResult1),
                             TestResultDisplayInfo(testResult: testResult2),
                             TestResultDisplayInfo(testResult: testResult3)]
                    displayInfo = TestResultsSectionDisplayInfo(title: title, items: items)
                }
                
                it("returns true") {
                    expect(displayInfo.hasItemsToAccept).to(beTrue())
                }
            }
            
            context("when there is no display info that can be accepted") {
                beforeEach {
                    let testResult1 = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo1/foo1.png", build: build)
                    let testResult2 = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo1/foo2.png", build: build)
                    let testResult3 = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo1/foo3.png", build: build)
                    items = [TestResultDisplayInfo(testResult: testResult1),
                             TestResultDisplayInfo(testResult: testResult2),
                             TestResultDisplayInfo(testResult: testResult3)]
                    displayInfo = TestResultsSectionDisplayInfo(title: title, items: items)
                }
                
                it("returns false") {
                    expect(displayInfo.hasItemsToAccept).to(beFalse())
                }
            }
        }
    }
}
