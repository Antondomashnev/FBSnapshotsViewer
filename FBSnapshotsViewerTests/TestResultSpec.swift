//
//  TestResultSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 13/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class PendingTestResultSpec: QuickSpec {
    override func spec() {
        describe(".init") {
            it("sets all parameters") {
                expect(PendingTestResult(testName: "myTestName").testName).to(equal("myTestName"))
            }
        }

        describe(".isCompleted") {
            var testResult: PendingTestResult!

            beforeEach {
                testResult = PendingTestResult(testName: "myTestName")
            }

            context("when reference image path is empty") {
                beforeEach {
                    testResult.failedImagePath = ".../failed_image.png"
                    testResult.diffImagePath = ".../diff_image.png"
                }

                it("is not completed") {
                    expect(testResult.isCompleted).to(beFalse())
                }
            }

            context("when failed image path is empty") {
                beforeEach {
                    testResult.referenceImagePath = ".../reference_image.png"
                    testResult.diffImagePath = ".../diff_image.png"
                }

                it("is not completed") {
                    expect(testResult.isCompleted).to(beFalse())
                }
            }

            context("when diff image path is empty") {
                beforeEach {
                    testResult.referenceImagePath = ".../reference_image.png"
                    testResult.failedImagePath = ".../failed_image.png"
                }

                it("is not completed") {
                    expect(testResult.isCompleted).to(beFalse())
                }
            }

            context("when all image pathes are not empty") {
                beforeEach {
                    testResult.referenceImagePath = ".../reference_image.png"
                    testResult.failedImagePath = ".../failed_image.png"
                    testResult.diffImagePath = ".../diff_image.png"
                }

                it("is completed") {
                    expect(testResult.isCompleted).to(beTrue())
                }
            }
        }

        describe(".completedTestResult") {
            var testResult: PendingTestResult!

            beforeEach {
                testResult = PendingTestResult(testName: "myTestName")
            }

            context("when is not completed") {
                it("returns nil") {
                    expect(testResult.completedTestResult).to(beNil())
                }
            }

            context("when is completed") {
                beforeEach {
                    testResult.referenceImagePath = ".../reference_image.png"
                    testResult.failedImagePath = ".../failed_image.png"
                    testResult.diffImagePath = ".../diff_image.png"
                }

                it("returns completed test result") {
                    expect(testResult.completedTestResult?.referenceImagePath).to(equal(testResult.referenceImagePath))
                    expect(testResult.completedTestResult?.failedImagePath).to(equal(testResult.failedImagePath))
                    expect(testResult.completedTestResult?.diffImagePath).to(equal(testResult.diffImagePath))
                }
            }
        }
    }
}
