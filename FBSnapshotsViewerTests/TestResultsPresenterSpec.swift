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

class TestResultsPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: TestResultsPresenter!
        var interactor: TestResultsInteractorInputMock!
        var userInterface: TestResultsUserInterfaceMock!

        beforeEach {
            interactor = TestResultsInteractorInputMock()
            userInterface = TestResultsUserInterfaceMock()
            presenter = TestResultsPresenter()
            presenter.interactor = interactor
            presenter.userInterface = userInterface
        }

        describe(".openInKaleidoscope") {
            var testResult: SnapshotTestResult!
            var testResultDisplayInfo: TestResultDisplayInfo!

            beforeEach {
                testResult = SnapshotTestResult.recorded(testName: "MyTest", referenceImagePath: "foo/bar.png")
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
                    testResults = [SnapshotTestResult.failed(testName: "testName", referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath")]
                    interactor.testResults = testResults
                    presenter.updateUserInterface()
                }

                it("shows test results in user interface") {
                    expect(userInterface.showCalled).to(beTrue())
                }

                it("shows correct test results in user interface") {
                    expect(userInterface.showReceivedTestResults?.count).to(equal(1))
                }
            }
        }
    }
}
