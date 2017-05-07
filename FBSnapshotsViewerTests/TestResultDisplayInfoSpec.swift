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
            let kaleidoscopeViewer: TestResultDisplayInfo_MockKaleidoscopeViewer.Type = TestResultDisplayInfo_MockKaleidoscopeViewer.self

            afterEach {
                kaleidoscopeViewer.reset()
            }

            describe("canBeViewedInKaleidoscope") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "testFailed", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png")
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
                    testResult = SnapshotTestResult.failed(testName: "testFailed", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png")
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer)
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
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, kaleidoscopeViewer: kaleidoscopeViewer)
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.testName).to(equal("testRecord"))
                }
            }
        }
    }
}
