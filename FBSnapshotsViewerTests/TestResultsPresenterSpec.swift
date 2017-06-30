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
    var swapCalledCounter: Int = 0
    override func swap(testResult: SnapshotTestResult) {
        super.swap(testResult: testResult)
        swapCalledCounter += 1
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
        
        describe(".swap") {
            var testResults: [TestResultDisplayInfo] = []
            
            beforeEach {
                let build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar"))
                let testInformation1 = SnapshotTestInformation(testClassName: "testClassName", testName: "testName1")
                let testResult1 = SnapshotTestResult.recorded(testInformation: testInformation1, referenceImagePath: "foo/bar/testName1.png", build: build)
                let testResultDisplayInfo1 = TestResultDisplayInfo(testResult: testResult1)
                let testInformation2 = SnapshotTestInformation(testClassName: "testClassName", testName: "testName2")
                let testResult2 = SnapshotTestResult.recorded(testInformation: testInformation2, referenceImagePath: "foo/bar/testName2.png", build: build)
                let testResultDisplayInfo2 = TestResultDisplayInfo(testResult: testResult2)
                testResults = [testResultDisplayInfo1, testResultDisplayInfo2]
                presenter.swap(testResults)
            }
            
            it("swaps all given test results") {
                expect(interactor.swapCalledCounter).to(equal(2))
            }
        }
        
        describe(".openInKaleidoscope") {
            var testResult: SnapshotTestResult!
            var testResultDisplayInfo: TestResultDisplayInfo!
            var build: Build!

            beforeEach {
                build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURL:  URL(fileURLWithPath: "foo/bar", isDirectory: true))
                testResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "MyTest"), referenceImagePath: "foo/bar.png", build: build)
                testResultDisplayInfo = TestResultDisplayInfo(testResult: testResult)
                presenter.openInKaleidoscope(testResultDisplayInfo: testResultDisplayInfo)
            }

            it("passes the message to interactor with correct test result") {
                expect(interactor.openInKaleidoscope_testResult_Called).to(beTrue())
                expect(interactor.openInKaleidoscope_testResult_ReceivedTestResult).to(equal(testResult))
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
                    let build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURL:  URL(fileURLWithPath: "foo/bar", isDirectory: true))
                    let snapshotTestResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)
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
                let build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURL:  URL(fileURLWithPath: "foo/bar", isDirectory: true))
                let snapshotTestResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)
                testResults = [snapshotTestResult]
                interactor.testResults = testResults
                presenter.selectDiffMode(TestResultsDiffMode.diff)
            }
            
            it("updates user interface") {
                expect(userInterface.show_displayInfo_Called).to(beTrue())
                expect(userInterface.show_displayInfo_ReceivedDisplayInfo?.testResultsDiffMode).to(equal(TestResultsDiffMode.diff))
            }
        }
    }
}
