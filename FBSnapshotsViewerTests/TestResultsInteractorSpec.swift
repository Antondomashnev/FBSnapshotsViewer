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

class TestResultsInteractor_MockSnapshotTestResultAcceptor: SnapshotTestResultAcceptor {
    var acceptThrows: Bool = false
    var acceptCalled: Bool = false
    var acceptTestResult: SnapshotTestResult?
    var acceptedTestResult: SnapshotTestResult!
    override func accept(_ testResult: SnapshotTestResult) throws -> SnapshotTestResult {
        acceptCalled = true
        acceptTestResult = testResult
        if acceptThrows {
            throw SnapshotTestResultAcceptorError.canNotBeAccepted(testResult: testResult)
        }
        return acceptedTestResult
    }
    
    var canAcceptReturnValue: Bool = false
    override func canAccept(_ testResult: SnapshotTestResult) -> Bool {
        return canAcceptReturnValue
    }
}

class TestResultsInteractorSpec: QuickSpec {
    override func spec() {
        let build: Build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
        let kaleidoscopeViewer: TestResultsInteractor_MockExternalViewer.Type = TestResultsInteractor_MockExternalViewer.self
        let xcodeViewer: TestResultsInteractor_MockExternalViewer.Type = TestResultsInteractor_MockExternalViewer.self
        var processLauncher: ProcessLauncher!
        var interactor: TestResultsInteractor!
        var pasteboard: PasteboardMock!
        var output: TestResultsInteractorOutputMock!
        var acceptor: TestResultsInteractor_MockSnapshotTestResultAcceptor!
        var testResults: [SnapshotTestResult] = []

        beforeEach {
            let testInformation1 = SnapshotTestInformation(testClassName: "testClassName", testName: "testName1", testFilePath: "/foo/testClassName.m", testLineNumber: 1)
            let testResult1 = SnapshotTestResult.failed(testInformation: testInformation1, referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", build: build)
            let testInformation2 = SnapshotTestInformation(testClassName: "testClassName", testName: "testName2", testFilePath: "/foo/testClassName.m", testLineNumber: 10)
            let testResult2 = SnapshotTestResult.recorded(testInformation: testInformation2, referenceImagePath: "referenceImagePath2", build: build)
            testResults = [testResult1, testResult2]
            processLauncher = ProcessLauncher()
            pasteboard = PasteboardMock()
            acceptor = TestResultsInteractor_MockSnapshotTestResultAcceptor()
            acceptor.acceptedTestResult = SnapshotTestResult.recorded(testInformation: testInformation1, referenceImagePath: "referenceImagePath1", build: build)
            output = TestResultsInteractorOutputMock()
            let builder = TestResultsInteractorBuilder {
                $0.testResults = testResults
                $0.externalViewers = ExternalViewers(xcodeViewer: xcodeViewer, kaleidoscopeViewer: kaleidoscopeViewer)
                $0.processLauncher = processLauncher
                $0.acceptor = acceptor
                $0.pasteboard = pasteboard
            }
            interactor = TestResultsInteractor(builder: builder)
            interactor.output = output
        }

        afterEach {
            kaleidoscopeViewer.reset()
        }
        
        describe(".accept") {
            var testResult: SnapshotTestResult!
            
            beforeEach {
                testResult = testResults[0]
            }
            
            context("when test result can not be accepted") {
                beforeEach {
                    acceptor.canAcceptReturnValue = false
                    interactor.accept(testResult: testResult)
                }
                
                it("does nothing") {
                    expect(acceptor.acceptCalled).to(beFalse())
                }
            }
            
            context("when test result can be accepted") {
                beforeEach {
                    acceptor.canAcceptReturnValue = true
                }
                
                context("when accept throws") {
                    beforeEach {
                        acceptor.acceptThrows = true
                        interactor.accept(testResult: testResult)
                    }
                    
                    it("outputs error") {
                        expect(output.didFailToAccept_testResult_with_Called).to(beTrue())
                    }
                }
                
                context("when accept doesn't throw") {
                    beforeEach {
                        acceptor.acceptThrows = false
                    }
                    
                    context("given presented test result") {
                        beforeEach {
                            interactor.accept(testResult: testResult)
                        }
                        
                        it("accepts") {
                            expect(acceptor.acceptCalled).to(beTrue())
                            expect(output.didFailToAccept_testResult_with_Called).toNot(beTrue())
                        }
                        
                        it("replaces failed test result with recorded") {
                            let testInformation = SnapshotTestInformation(testClassName: testResult.testClassName, testName: testResult.testName, testFilePath: testResult.testFilePath, testLineNumber: testResult.testLineNumber)
                            let expectedRecordedTestResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "referenceImagePath1", build: build)
                            expect(interactor.testResults[0]).to(equal(expectedRecordedTestResult))
                        }
                    }
                    
                    context("given not presented test result") {
                        beforeEach {
                            let testInformation = SnapshotTestInformation(testClassName: "Foo", testName: "Bar", testFilePath: "/Baz/Foo.m", testLineNumber: 1)
                            let notPresentedTestResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "foo/bar@2x.png", diffImagePath: "foo/bar@2x.png", failedImagePath: "foo/bar@2x.png", build: build)
                            interactor.accept(testResult: notPresentedTestResult)
                        }
                        
                        it("outputs error") {
                            expect(output.didFailToAccept_testResult_with_Called).to(beTrue())
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
        }
        
        describe(".openInXcode") {
            context("when xcode viewer is available") {
                beforeEach {
                    xcodeViewer.isAvailableReturnValue = true
                }
                
                context("and can view the test resukt") {
                    beforeEach {
                        xcodeViewer.canViewReturnValue = true
                    }
                    
                    it("views the test result") {
                        interactor.openInXcode(testResult: testResults[0])
                        expect(xcodeViewer.viewParameters?.snapshotTestResult).to(equal(testResults[0]))
                    }
                }
                
                context("and can not view the test resukt") {
                    beforeEach {
                        xcodeViewer.canViewReturnValue = false
                    }
                    
                    it("asserts") {
                        expect { interactor.openInXcode(testResult: testResults[0]) }.to(throwAssertion())
                    }
                }
            }
            
            context("when xcode viewer is not available") {
                beforeEach {
                    xcodeViewer.isAvailableReturnValue = false
                }
                
                it("asserts") {
                    expect { interactor.openInXcode(testResult: testResults[0]) }.to(throwAssertion())
                }
            }
        }
        
        describe(".copy") {
            context("recorded snapshot test result") {
                var testResult: SnapshotTestResult!
                
                beforeEach {
                    testResult = testResults[1]
                    interactor.copy(testResult: testResult)
                }
                
                it("copies recorded image url") {
                    expect(pasteboard.copyImage_at_Called).to(beTrue())
                    expect(pasteboard.copyImage_at_ReceivedUrl).to(equal(URL(fileURLWithPath: "referenceImagePath2")))
                }
            }
            
            context("failed snapshot test result") {
                var testResult: SnapshotTestResult!
                
                beforeEach {
                    testResult = testResults[0]
                    interactor.copy(testResult: testResult)
                }
                
                it("copies failed image url") {
                    expect(pasteboard.copyImage_at_Called).to(beTrue())
                    expect(pasteboard.copyImage_at_ReceivedUrl).to(equal(URL(fileURLWithPath: "failedImagePath1")))
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
