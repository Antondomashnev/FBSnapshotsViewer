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
                build = Build(applicationName: "FBSnapshotsViewer")
                testResult = SnapshotTestResult.recorded(testName: "MyTest", referenceImagePath: "foo/bar.png", build: build)
                testResultDisplayInfo = TestResultDisplayInfo(testResult: testResult)
                presenter.openInKaleidoscope(testResultDisplayInfo: testResultDisplayInfo)
            }

            it("passes the message to interactor with correct test result") {
                expect(interactor.openInKaleidoscopeCalled).to(beTrue())
                expect(interactor.openInKaleidoscopeReceivedTestResult).to(equal(testResult))
            }
        }

        describe(".updateUserInterface") {
            context("when interactor doesn't have test results") {
                beforeEach {
                    presenter.updateUserInterface()
                }

                it("doesn't show test results in user interface") {
                    expect(userInterface.showCalled).to(beFalse())
                }
            }

            context("when interactor has test results") {
                var testResults: [SnapshotTestResult] = []

                beforeEach {
                    let build = Build(applicationName: "FBSnapshotsViewer")
                    let snapshotTestResult = SnapshotTestResult.failed(testName: "testName", referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)
                    let titleInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "Context")
                    let sectionInfo = TestResultsSectionDisplayInfo(title: titleInfo, items: [TestResultDisplayInfo(testResult: snapshotTestResult)])
                    testResults = [snapshotTestResult]
                    interactor.testResults = testResults
                    testResultsCollector.collectedTestResults = [sectionInfo, sectionInfo]
                    presenter.updateUserInterface()
                }

                it("shows test results in user interface") {
                    expect(userInterface.showCalled).to(beTrue())
                }

                it("shows correct test results in user interface") {
                    expect(userInterface.showReceivedTestResults?.count).to(equal(2))
                }
                
                it("uses collector") {
                    expect(testResultsCollector.collectCalledTestResults).to(equal(testResults))
                }
            }
        }
    }
}
