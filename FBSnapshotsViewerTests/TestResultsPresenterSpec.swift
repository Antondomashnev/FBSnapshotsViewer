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

class TestResultsPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: TestResultsPresenter!
        var interactor: TestResultsInteractorInputMock!
        var userInterface: TestResultsUserInterfaceMock!
        var testResultsCollector: TestResultsPresenter_MockTestResultsDisplayInfosCollector!

        beforeEach {
            testResultsCollector = TestResultsPresenter_MockTestResultsDisplayInfosCollector()
            interactor = TestResultsInteractorInputMock()
            userInterface = TestResultsUserInterfaceMock()
            presenter = TestResultsPresenter(testResultsCollector: testResultsCollector)
            presenter.interactor = interactor
            presenter.userInterface = userInterface
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
                expect(interactor.openInKaleidoscopetestResultCalled).to(beTrue())
                expect(interactor.openInKaleidoscopetestResultReceivedTestResult).to(equal(testResult))
            }
        }

        describe(".updateUserInterface") {
            context("when interactor doesn't have test results") {
                beforeEach {
                    presenter.updateUserInterface()
                }

                it("doesn't show test results in user interface") {
                    expect(userInterface.showdisplayInfoCalled).to(beFalse())
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
                    expect(userInterface.showdisplayInfoCalled).to(beTrue())
                }

                it("shows correct test results in user interface") {
                    expect(userInterface.showdisplayInfoReceivedDisplayInfo).to(equal(expectTestResultsDisplayInfo))
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
                expect(userInterface.showdisplayInfoCalled).to(beTrue())
                expect(userInterface.showdisplayInfoReceivedDisplayInfo?.testResultsDiffMode).to(equal(TestResultsDiffMode.diff))
            }
        }
    }
}
