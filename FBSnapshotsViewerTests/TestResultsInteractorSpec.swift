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

class TestResultsInteractor_MockExternalViewer: ExternalViewer {
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

class TestResultsInteractor_MockSnapshotTestResultSwapper: SnapshotTestResultSwapper {
    var swapThrows: Bool = false
    var swapCalled: Bool = false
    var swapTestResult: SnapshotTestResult?
    override func swap(_ testResult: SnapshotTestResult) throws {
        swapCalled = true
        swapTestResult = testResult
        if swapThrows {
            throw SnapshotTestResultSwapperError.canNotBeSwapped(testResult: testResult)
        }
    }
    
    var canSwapReturnValue: Bool = false
    override func canSwap(_ testResult: SnapshotTestResult) -> Bool {
        return canSwapReturnValue
    }
}

class TestResultsInteractorSpec: QuickSpec {
    override func spec() {
        let build: Build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
        let kaleidoscopeViewer: TestResultsInteractor_MockExternalViewer.Type = TestResultsInteractor_MockExternalViewer.self
        var processLauncher: ProcessLauncher!
        var interactor: TestResultsInteractor!
        var testResults: [SnapshotTestResult] = []

        beforeEach {
            let testResult1 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName1"), referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", build: build)
            let testResult2 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName2"), referenceImagePath: "referenceImagePath2", build: build)
            testResults = [testResult1, testResult2]
            processLauncher = ProcessLauncher()
            interactor = TestResultsInteractor(testResults: testResults, kaleidoscopeViewer: kaleidoscopeViewer, processLauncher: processLauncher)
        }

        afterEach {
            kaleidoscopeViewer.reset()
        }
        
        describe(".swap") {
            
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
