//
//  TestResultDisplayInfoSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class TestResultDisplayInfo_MockDateComponentsFormatter: DateComponentsFormatter {
    override func string(from startDate: Date, to endDate: Date) -> String? {
        return "10 minutes ago"
    }
}

class TestResultDisplayInfo_MockKaleidoscopeViewer: ExternalViewer {
    static var name: String = ""
    static var bundleID: String = ""

    static var canViewReturnValue: Bool = false
    static func canView(snapshotTestResult: SnapshotTestResult) -> Bool {
        return canViewReturnValue
    }

    static func view(snapshotTestResult: SnapshotTestResult, using processLauncher: ProcessLauncher = ProcessLauncher()) {
        // Do nothing
    }

    static var isAvailableReturnValue: Bool = false
    static func isAvailable(osxApplicationFinder: OSXApplicationFinder) -> Bool {
        return isAvailableReturnValue
    }

    static func reset() {
        isAvailableReturnValue = false
        canViewReturnValue = false
        name = ""
        bundleID = ""
    }
}

class TestResultDisplayInfoSpec: QuickSpec {
    override func spec() {
        describe(".initWithTestInfo") {
            var testResult: SnapshotTestResult!
            var dateFormatter: TestResultDisplayInfo_MockDateComponentsFormatter!
            let kaleidoscopeViewer: TestResultDisplayInfo_MockKaleidoscopeViewer.Type = TestResultDisplayInfo_MockKaleidoscopeViewer.self

            beforeEach {
                dateFormatter = TestResultDisplayInfo_MockDateComponentsFormatter()
            }

            afterEach {
                kaleidoscopeViewer.reset()
            }

            describe("testName") {
                context("when test name with undrscore") {
                    beforeEach {
                        testResult = SnapshotTestResult.failed(testName: "TestClass_testName_has_replaced_all_underscore_with_spaces", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", createdAt: Date())
                    }

                    it("has correct test name") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult)
                        expect(displayInfo.testName).to(equal("spaces"))
                    }

                    it("has correct test context") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult)
                        expect(displayInfo.testContext).to(equal("TestClass testName has replaced all underscore with"))
                    }
                }

                context("when test name without undrscore") {
                    beforeEach {
                        testResult = SnapshotTestResult.failed(testName: "TestClass testName", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", createdAt: Date())
                    }

                    it("has correct test name") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult)
                        expect(displayInfo.testName).to(equal("testName"))
                    }

                    it("has correct test context") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult)
                        expect(displayInfo.testContext).to(equal("TestClass"))
                    }
                }
            }

            describe("canBeViewedInKaleidoscope") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "testFailed", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", createdAt: Date())
                }

                context("when kaleidoscope viewer is available") {
                    beforeEach {
                        kaleidoscopeViewer.isAvailableReturnValue = true
                    }

                    context("and can show test result") {
                        beforeEach {
                            kaleidoscopeViewer.canViewReturnValue = true
                        }

                        it("can be viewed in kaleidoscope") {
                            let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer)
                            expect(displayInfo.canBeViewedInKaleidoscope).to(beTrue())
                        }
                    }

                    context("and can not show test result") {
                        beforeEach {
                            kaleidoscopeViewer.canViewReturnValue = false
                        }

                        it("can not be viewed in kaleidoscope") {
                            let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer)
                            expect(displayInfo.canBeViewedInKaleidoscope).to(beFalse())
                        }
                    }
                }

                context("when kaleidoscope viewer is not available") {
                    beforeEach {
                        kaleidoscopeViewer.isAvailableReturnValue = false
                    }

                    it("can not be viewed in kaleidoscope") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer)
                        expect(displayInfo.canBeViewedInKaleidoscope).to(beFalse())
                    }
                }
            }

            context("when failed test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "TestClass testFailed", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", createdAt: Date())
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer, dateFormatter: dateFormatter)
                    expect(displayInfo.diffImageURL).to(equal(URL(fileURLWithPath: "diffImagePath.png")))
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.failedImageURL).to(equal(URL(fileURLWithPath: "failedImagePath.png")))
                    expect(displayInfo.testName).to(equal("testFailed"))
                    expect(displayInfo.testContext).to(equal("TestClass"))
                    expect(displayInfo.testResult).to(equal(testResult))
                    expect(displayInfo.createdAt).to(equal("10 minutes ago"))
                }
            }

            context("when recorded test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testName: "ExampleTestClass testRecord", referenceImagePath: "referenceImagePath.png", createdAt: Date())
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer, dateFormatter: dateFormatter)
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.testName).to(equal("testRecord"))
                    expect(displayInfo.testContext).to(equal("ExampleTestClass"))
                    expect(displayInfo.createdAt).to(equal("10 minutes ago"))
                }
            }
        }
    }
}
