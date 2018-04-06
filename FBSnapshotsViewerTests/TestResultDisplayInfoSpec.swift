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

class TestResultDisplayInfo_MockXcodeViewer: ExternalViewer {
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

class TestResultDisplayInfo_MockSnapshotTestResultAcceptor: SnapshotTestResultAcceptor {
    var canAcceptReturnValue: Bool = false
    override func canAccept(_ testResult: SnapshotTestResult) -> Bool {
        return canAcceptReturnValue
    }
}

class TestResultDisplayInfoSpec: QuickSpec {
    override func spec() {
        describe(".initWithTestInfo") {
            var build: Build!
            var testInformation: SnapshotTestInformation!
            var testResult: SnapshotTestResult!
            var acceptor: TestResultDisplayInfo_MockSnapshotTestResultAcceptor!
            var externalViewers: ExternalViewers!
            let kaleidoscopeViewer: TestResultDisplayInfo_MockKaleidoscopeViewer.Type = TestResultDisplayInfo_MockKaleidoscopeViewer.self
            let xcodeViewer: TestResultDisplayInfo_MockXcodeViewer.Type = TestResultDisplayInfo_MockXcodeViewer.self

            afterEach {
                kaleidoscopeViewer.reset()
            }
            
            beforeEach {
                externalViewers = ExternalViewers(xcodeViewer: xcodeViewer, kaleidoscopeViewer: kaleidoscopeViewer)
                acceptor = TestResultDisplayInfo_MockSnapshotTestResultAcceptor()
                build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
            }
            
            describe("testName") {
                context("given test name from Quick") {
                    beforeEach {
                        testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "_view__looks_good_iPhone9_3_375x667", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                        testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
                    }

                    it("has correct test name") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult)
                        expect(displayInfo.testName).to(equal("looks good iPhone9 3 375x667"))
                    }

                    it("has correct test context") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult)
                        expect(displayInfo.testContext).to(equal("TestClass view"))
                    }
                }

                context("given text name from XCTest") {
                    beforeEach {
                        testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "testName", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                        testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
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
            
            describe("canBeAccepted") {
                var displayInfo: TestResultDisplayInfo!
                
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "testFailed", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
                }
                
                context("when acceptor can accept given test result") {
                    beforeEach {
                        acceptor.canAcceptReturnValue = true
                        displayInfo = TestResultDisplayInfo(testResult: testResult, acceptor: acceptor)
                    }
                    
                    it("can be accepted") {
                        expect(displayInfo.canBeAccepted).to(beTrue())
                    }
                }
                
                context("when acceptor can not accept given test result") {
                    beforeEach {
                        acceptor.canAcceptReturnValue = false
                        displayInfo = TestResultDisplayInfo(testResult: testResult, acceptor: acceptor)
                    }
                    
                    it("can not be accepted") {
                        expect(displayInfo.canBeAccepted).to(beFalse())
                    }
                }
            }
            
            describe("canBeViewedInKaleidoscope") {
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "testFailed", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
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
                            let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                            expect(displayInfo.canBeViewedInKaleidoscope).to(beTrue())
                        }
                    }

                    context("and can not show test result") {
                        beforeEach {
                            kaleidoscopeViewer.canViewReturnValue = false
                        }

                        it("can not be viewed in kaleidoscope") {
                            let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                            expect(displayInfo.canBeViewedInKaleidoscope).to(beFalse())
                        }
                    }
                }

                context("when kaleidoscope viewer is not available") {
                    beforeEach {
                        kaleidoscopeViewer.isAvailableReturnValue = false
                    }

                    it("can not be viewed in kaleidoscope") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                        expect(displayInfo.canBeViewedInKaleidoscope).to(beFalse())
                    }
                }
            }
            
            describe("canBeCopied") {
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "testFailed", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
                }
                
                it("can be") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                    expect(displayInfo.canBeCopied).to(beTrue())
                }
            }
            
            describe("canBeViewedInXcode") {
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "testFailed", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
                }
                
                context("when xcode viewer is available") {
                    beforeEach {
                        xcodeViewer.isAvailableReturnValue = true
                    }
                    
                    context("and can show test result") {
                        beforeEach {
                            xcodeViewer.canViewReturnValue = true
                        }
                        
                        it("can be viewed in xcode") {
                            let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                            expect(displayInfo.canBeViewedInXcode).to(beTrue())
                        }
                    }
                    
                    context("and can not show test result") {
                        beforeEach {
                            xcodeViewer.canViewReturnValue = false
                        }
                        
                        it("can not be viewed in xcode") {
                            let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                            expect(displayInfo.canBeViewedInXcode).to(beFalse())
                        }
                    }
                }
                
                context("when xcode viewer is not available") {
                    beforeEach {
                        xcodeViewer.isAvailableReturnValue = false
                    }
                    
                    it("can not be viewed in xcode") {
                        let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                        expect(displayInfo.canBeViewedInXcode).to(beFalse())
                    }
                }
            }

            context("when failed test result") {
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "TestClass", testName: "testFailed", testFilePath: "foo/TestClass.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build)
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                    expect(displayInfo.diffImageURL).to(equal(URL(fileURLWithPath: "diffImagePath.png")))
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.failedImageURL).to(equal(URL(fileURLWithPath: "failedImagePath.png")))
                    expect(displayInfo.testName).to(equal("testFailed"))
                    expect(displayInfo.testContext).to(equal("TestClass"))
                    expect(displayInfo.testResult).to(equal(testResult))
                }
            }

            context("when recorded test result") {
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "ExampleTestClass", testName: "testRecord", testFilePath: "foo/ExampleTestClass.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "referenceImagePath.png", build: build)
                }

                it("initializes object correctly") {
                    let displayInfo = TestResultDisplayInfo(testResult: testResult, externalViewers: externalViewers)
                    expect(displayInfo.referenceImageURL).to(equal(URL(fileURLWithPath: "referenceImagePath.png")))
                    expect(displayInfo.testName).to(equal("testRecord"))
                    expect(displayInfo.testContext).to(equal("ExampleTestClass"))
                }
            }
        }
    }
}
