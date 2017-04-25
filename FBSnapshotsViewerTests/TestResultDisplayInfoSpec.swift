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
        describe(".initWithTestInfo") {
            var testResult: SnapshotTestResult!

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

        describe(".init") {
            it("initializes all properties") {
                let displayInfo = TestResultDisplayInfo(referenceImageURL: URL(fileURLWithPath: "referenceImagePath.png"), diffImageURL: URL(fileURLWithPath: "diffImagePath.png"), failedImageURL: URL(fileURLWithPath: "failedImagePath.png"), testName: "testName")
                expect(displayInfo.diffImageURL).to(equal(URL(fileURLWithPath: "diffImagePath.png")))
                expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                expect(displayInfo.failedImageURL).to(equal(URL(fileURLWithPath: "failedImagePath.png")))
                expect(displayInfo.testName).to(equal("testName"))
            }
        }
    }
}
