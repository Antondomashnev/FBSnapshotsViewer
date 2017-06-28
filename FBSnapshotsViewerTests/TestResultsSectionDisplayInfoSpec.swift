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
                let build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
                let testResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "foo/bar.png", build: build)
                title = TestResultsSectionTitleDisplayInfo(build: build, testContext: "TestContext")
                items = [TestResultDisplayInfo(testResult: testResult)]
                displayInfo = TestResultsSectionDisplayInfo(title: title, items: items)
            }
            
            it("initializes all properties") {
                expect(displayInfo.itemInfos).to(equal(items))
                expect(displayInfo.titleInfo).to(equal(title))
            }
        }
    }
}
