//
//  TestResultsPresenterSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsPresenter_MockTestResultsDisplayInfosCollector: TestResultsDisplayInfosCollector {
    var collectedTestResults: [TestResultsSectionDisplayInfo] = []
    var collectCalledTestResults: [SnapshotTestResult] = []
    override func collect(testResults: [SnapshotTestResult]) -> [TestResultsSectionDisplayInfo] {
        collectCalledTestResults = testResults
        return collectedTestResults
    }
}

class TestResultsPresenter_MockTestResultsInteractorInputMock: TestResultsInteractorInputMock {
    var acceptCalledCounter: Int = 0
    override func accept(testResult: SnapshotTestResult) {
        super.accept(testResult: testResult)
        acceptCalledCounter += 1
    }
}

class TestResultsPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: TestResultsPresenter!
        var interactor: TestResultsPresenter_MockTestResultsInteractorInputMock!
        var userInterface: TestResultsUserInterfaceMock!
        var testResultsCollector: TestResultsPresenter_MockTestResultsDisplayInfosCollector!

        beforeEach {
            testResultsCollector = TestResultsPresenter_MockTestResultsDisplayInfosCollector()
            interactor = TestResultsPresenter_MockTestResultsInteractorInputMock()
            userInterface = TestResultsUserInterfaceMock()
            presenter = TestResultsPresenter(testResultsCollector: testResultsCollector)
            presenter.interactor = interactor
            presenter.userInterface = userInterface
        }
        
        describe(".accept") {
            var testResults: [TestResultDisplayInfo] = []
            
            beforeEach {
                let build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar")])
                let testInformation1 = SnapshotTestInformation(testClassName: "testClassName", testName: "testName1", testFilePath: "testFilePath", testLineNumber: 0)
                let testResult1 = SnapshotTestResult.recorded(testInformation: testInformation1, referenceImagePath: "foo/bar/testName1.png", build: build)
                let testResultDisplayInfo1 = TestResultDisplayInfo(testResult: testResult1)
                let testInformation2 = SnapshotTestInformation(testClassName: "testClassName", testName: "testName2", testFilePath: "testFilePath", testLineNumber: 0)
                let testResult2 = SnapshotTestResult.recorded(testInformation: testInformation2, referenceImagePath: "foo/bar/testName2.png", build: build)
                let testResultDisplayInfo2 = TestResultDisplayInfo(testResult: testResult2)
                testResults = [testResultDisplayInfo1, testResultDisplayInfo2]
                interactor.testResults = [testResult1, testResult2]
                presenter.accept(testResults)
            }
            
            it("accepts all given test results") {
                expect(interactor.acceptCalledCounter).to(equal(2))
            }
            
            it("updates user interface") {
                expect(userInterface.show_displayInfo_Called).to(beTrue())
            }
        }
        
        describe(".openInKaleidoscope") {
            var testResult: SnapshotTestResult!
            var testResultDisplayInfo: TestResultDisplayInfo!
            var build: Build!
            var testInformation: SnapshotTestInformation!

            beforeEach {
                build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "MyTest", testFilePath: "testFilePath", testLineNumber: 1)
                testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo/bar.png", build: build)
                testResultDisplayInfo = TestResultDisplayInfo(testResult: testResult)
                presenter.openInKaleidoscope(testResultDisplayInfo: testResultDisplayInfo)
            }

            it("passes the message to interactor with correct test result") {
                expect(interactor.openInKaleidoscope_testResult_Called).to(beTrue())
                expect(interactor.openInKaleidoscope_testResult_ReceivedTestResult).to(equal(testResult))
            }
        }
        
        describe(".openInXcode") {
            var testResult: SnapshotTestResult!
            var testResultDisplayInfo: TestResultDisplayInfo!
            var build: Build!
            var testInformation: SnapshotTestInformation!
            
            beforeEach {
                build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "MyTest", testFilePath: "testFilePath", testLineNumber: 1)
                testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo/bar.png", build: build)
                testResultDisplayInfo = TestResultDisplayInfo(testResult: testResult)
                presenter.openInXcode(testResultDisplayInfo: testResultDisplayInfo)
            }
            
            it("passes the message to interactor with correct test result") {
                expect(interactor.openInXcode_testResult_Called).to(beTrue())
                expect(interactor.openInXcode_testResult_ReceivedTestResult).to(equal(testResult))
            }
        }

        describe(".updateUserInterface") {
            context("when interactor doesn't have test results") {
                beforeEach {
                    presenter.updateUserInterface()
                }

                it("doesn't show test results in user interface") {
                    expect(userInterface.show_displayInfo_Called).to(beFalse())
                }
            }

            context("when interactor has test results") {
                var expectTestResultsDisplayInfo: TestResultsDisplayInfo!
                var testResults: [SnapshotTestResult] = []

                beforeEach {
                    let build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                    let testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "MyTest", testFilePath: "testFilePath", testLineNumber: 1)
                    let snapshotTestResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)
                    let titleInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "Context")
                    let sectionInfo = TestResultsSectionDisplayInfo(title: titleInfo, items: [TestResultDisplayInfo(testResult: snapshotTestResult)])
                    testResults = [snapshotTestResult]
                    interactor.testResults = testResults
                    testResultsCollector.collectedTestResults = [sectionInfo, sectionInfo]
                    expectTestResultsDisplayInfo = TestResultsDisplayInfo(sectionInfos: testResultsCollector.collectedTestResults, testResultsDiffMode: .mouseOver)
                    presenter.updateUserInterface()
                }

                it("shows test results in user interface") {
                    expect(userInterface.show_displayInfo_Called).to(beTrue())
                }

                it("shows correct test results in user interface") {
                    expect(userInterface.show_displayInfo_ReceivedDisplayInfo).to(equal(expectTestResultsDisplayInfo))
                }
                
                it("uses collector") {
                    expect(testResultsCollector.collectCalledTestResults).to(equal(testResults))
                }
            }
        }
        
        describe(".selectDiffMode") {
            var testResults: [SnapshotTestResult] = []
            
            beforeEach {
                let build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                let testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "testName", testFilePath: "testFilePath", testLineNumber: 1)
                let snapshotTestResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)
                testResults = [snapshotTestResult]
                interactor.testResults = testResults
                presenter.selectDiffMode(TestResultsDiffMode.diff)
            }
            
            it("updates user interface") {
                expect(userInterface.show_displayInfo_Called).to(beTrue())
                expect(userInterface.show_displayInfo_ReceivedDisplayInfo?.testResultsDiffMode).to(equal(TestResultsDiffMode.diff))
            }
        }
        
        describe("copy") {
            var testResult: SnapshotTestResult!
            var testResultDisplayInfo: TestResultDisplayInfo!
            var build: Build!
            var testInformation: SnapshotTestInformation!
        
            beforeEach {
                build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                testInformation = SnapshotTestInformation(testClassName: "testClassName", testName: "MyTest", testFilePath: "testFilePath", testLineNumber: 1)
                testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo/bar.png", build: build)
                testResultDisplayInfo = TestResultDisplayInfo(testResult: testResult)
                presenter.copy(testResultDisplayInfo: testResultDisplayInfo)
            }
            
            it("passes the message to interactor with correct test result") {
                expect(interactor.copy_testResult_Called).to(beTrue())
                expect(interactor.copy_testResult_ReceivedTestResult).to(equal(testResult))
            }
        }
    }
}
