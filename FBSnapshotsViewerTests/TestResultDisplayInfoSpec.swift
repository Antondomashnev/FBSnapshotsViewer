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

            context("when failed test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "testFailed", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png")
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult)
                    expect(displayInfo.diffImageURL).to(equal(URL(fileURLWithPath: "diffImagePath.png")))
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.failedImageURL).to(equal(URL(fileURLWithPath: "failedImagePath.png")))
                    expect(displayInfo.testName).to(equal("testFailed"))
                    expect(displayInfo.testResult).to(equal(testResult))
                }
            }

            context("when recorded test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testName: "testRecord", referenceImagePath: "referenceImagePath.png")
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult)
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.testName).to(equal("testRecord"))
                }
            }
        }
    }
}
