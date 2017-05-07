//
//  TestResultsInteractorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsInteractor_Mock: ExternalViewer {
    static var name: String { return "" }
    static var bundleID: String { return "" }

    static var isAvailableReturnValue: Bool = false
    static func isAvailable(osxApplicationFinder: OSXApplicationFinder) -> Bool {
        return isAvailableReturnValue
    }

    static var canViewReturnValue: Bool = false
    static func canView(snapshotTestResult: SnapshotTestResult) -> Bool {
        return canViewReturnValue
    }

    static var viewParameters: (snapshotTestResult: SnapshotTestResult, processLauncher: ProcessLauncher)?
    static func view(snapshotTestResult: SnapshotTestResult, using processLauncher: ProcessLauncher) {
        viewParameters = (snapshotTestResult: snapshotTestResult, processLauncher: processLauncher)
    }

    static func reset() {
        viewParameters = nil
        canViewReturnValue = false
        isAvailableReturnValue = false
    }
}

class TestResultsInteractorSpec: QuickSpec {
    override func spec() {
        let kaleidoscopeViewer: TestResultsInteractor_Mock.Type = TestResultsInteractor_Mock.self
        var processLauncher: ProcessLauncher!
        var interactor: TestResultsInteractor!
        var testResults: [SnapshotTestResult] = []

        beforeEach {
            let testResult1 = SnapshotTestResult.failed(testName: "testName1", referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1")
            let testResult2 = SnapshotTestResult.recorded(testName: "testName2", referenceImagePath: "referenceImagePath2")
            testResults = [testResult1, testResult2]
            processLauncher = ProcessLauncher()
            interactor = TestResultsInteractor(testResults: testResults, kaleidoscopeViewer: kaleidoscopeViewer, processLauncher: processLauncher)
        }

        afterEach {
            kaleidoscopeViewer.reset()
        }

        describe(".openInKaleidoscope") {
            context("when kaleidoscope viewer is available") {
                beforeEach {
                    kaleidoscopeViewer.isAvailableReturnValue = true
                }

                context("and can view the test resukt") {
                    beforeEach {
                        kaleidoscopeViewer.canViewReturnValue = true
                    }

                    it("views the test result") {
                        interactor.openInKaleidoscope(testResult: testResults[0])
                        expect(kaleidoscopeViewer.viewParameters?.snapshotTestResult).to(equal(testResults[0]))
                    }
                }

                context("and can not view the test resukt") {
                    beforeEach {
                        kaleidoscopeViewer.canViewReturnValue = false
                    }

                    it("asserts") {
                        expect { interactor.openInKaleidoscope(testResult: testResults[0]) }.to(throwAssertion())
                    }
                }
            }

            context("when kaleidoscope viewer is not available") {
                beforeEach {
                    kaleidoscopeViewer.isAvailableReturnValue = false
                }

                it("asserts") {
                    expect { interactor.openInKaleidoscope(testResult: testResults[0]) }.to(throwAssertion())
                }
            }
        }

        describe(".testResults") {
            it("returns initialized test results") {
                expect(interactor.testResults.count).to(equal(2))
            }
        }
    }
}
