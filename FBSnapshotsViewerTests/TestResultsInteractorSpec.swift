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
    var swappedTestResult: SnapshotTestResult!
    override func swap(_ testResult: SnapshotTestResult) throws -> SnapshotTestResult {
        swapCalled = true
        swapTestResult = testResult
        if swapThrows {
            throw SnapshotTestResultSwapperError.canNotBeSwapped(testResult: testResult)
        }
        return swappedTestResult
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
        var output: TestResultsInteractorOutputMock!
        var swapper: TestResultsInteractor_MockSnapshotTestResultSwapper!
        var testResults: [SnapshotTestResult] = []

        beforeEach {
            let testResult1 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName1"), referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", build: build)
            let testResult2 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName2"), referenceImagePath: "referenceImagePath2", build: build)
            testResults = [testResult1, testResult2]
            processLauncher = ProcessLauncher()
            swapper = TestResultsInteractor_MockSnapshotTestResultSwapper()
            swapper.swappedTestResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName1"), referenceImagePath: "referenceImagePath1", build: build)
            output = TestResultsInteractorOutputMock()
            interactor = TestResultsInteractor(testResults: testResults, kaleidoscopeViewer: kaleidoscopeViewer, processLauncher: processLauncher, swapper: swapper)
            interactor.output = output
        }

        afterEach {
            kaleidoscopeViewer.reset()
        }
        
        describe(".swap") {
            var testResult: SnapshotTestResult!
            
            beforeEach {
                testResult = testResults[0]
            }
            
            context("when test result can not be swapped") {
                beforeEach {
                    swapper.canSwapReturnValue = false
                    interactor.swap(testResult: testResult)
                }
                
                it("does nothing") {
                    expect(swapper.swapCalled).to(beFalse())
                }
            }
            
            context("when test result can be swapped") {
                beforeEach {
                    swapper.canSwapReturnValue = true
                }
                
                context("when swap throws") {
                    beforeEach {
                        swapper.swapThrows = true
                        interactor.swap(testResult: testResult)
                    }
                    
                    it("outputs error") {
                        expect(output.didFailToSwap_testResult_with_Called).to(beTrue())
                    }
                }
                
                context("when swap doesn't throw") {
                    beforeEach {
                        swapper.swapThrows = false
                    }
                    
                    context("given presented test result") {
                        beforeEach {
                            interactor.swap(testResult: testResult)
                        }
                        
                        it("swaps") {
                            expect(swapper.swapCalled).to(beTrue())
                            expect(output.didFailToSwap_testResult_with_Called).toNot(beTrue())
                        }
                        
                        it("replaces failed test result with recorded") {
                            let testInformation = SnapshotTestInformation(testClassName: testResult.testClassName, testName: testResult.testName)
                            let expectedRecordedTestResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "referenceImagePath1", build: build)
                            expect(interactor.testResults[0]).to(equal(expectedRecordedTestResult))
                        }
                    }
                    
                    context("given not presented test result") {
                        beforeEach {
                            let testInformation = SnapshotTestInformation(testClassName: "Foo", testName: "Bar")
                            let notPresentedTestResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "foo/bar@2x.png", diffImagePath: "foo/bar@2x.png", failedImagePath: "foo/bar@2x.png", build: build)
                            interactor.swap(testResult: notPresentedTestResult)
                        }
                        
                        it("outputs error") {
                            expect(output.didFailToSwap_testResult_with_Called).to(beTrue())
                        }
                    }
                }
            }
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
