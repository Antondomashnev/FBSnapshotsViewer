//
//  TestResultDisplayInfoSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultDisplayInfoSpec: QuickSpec {
    override func spec() {
        describe(".init") {
            var testResult: TestResult!

            beforeEach {
                testResult = CompletedTestResult(referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", testName: "testName")
            }

            it("initializes all properties") {
                let displayInfo = TestResultDisplayInfo(testResult: testResult)
                expect(displayInfo.diffImageURL).to(equal(URL(fileURLWithPath: "diffImagePath.png")))
                expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                expect(displayInfo.failedImageURL).to(equal(URL(fileURLWithPath: "failedImagePath.png")))
                expect(displayInfo.testName).to(equal("testName"))
            }
        }
    }
}
