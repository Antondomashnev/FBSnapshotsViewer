//
//  MenuPresenterSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 06/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class MenuPresenter_MockMenuWireframe: MenuWireframe {
    var showTestResultsModuleCalled: Bool = false
    var showTestResultsModuleReceivedParameters: [SnapshotTestResult] = []

    override func showTestResultsModule(with testResults: [SnapshotTestResult]) {
        showTestResultsModuleCalled = true
        showTestResultsModuleReceivedParameters = testResults
    }
}

class MenuPresenterSpec: QuickSpec {
    override func spec() {
        var derivedDataFolder: DerivedDataFolder!
        var application: ApplicationMock!
        var userInterface: MenuUserInterfaceMock!
        var presenter: MenuPresenter!
        var interactor: MenuInteractorInputMock!
        var wireframe: MenuPresenter_MockMenuWireframe!

        beforeEach {
            derivedDataFolder = DerivedDataFolder(path: "Users/antondomashnev/Library/Xcode/temporaryFolder")
            application = ApplicationMock()
            wireframe = MenuPresenter_MockMenuWireframe()
            interactor = MenuInteractorInputMock()
            presenter = MenuPresenter(derivedDataFolder: derivedDataFolder, application: application)
            userInterface = MenuUserInterfaceMock()
            presenter.userInterface = userInterface
            presenter.interactor = interactor
            presenter.wireframe = wireframe
        }

        describe(".start") {
            beforeEach {
                presenter.start()
            }

            it("starts the Xcode builds listening") {
                expect(interactor.startXcodeBuildsListeningReceivedDerivedDataFolder).to(equal(derivedDataFolder))
            }
        }

        describe(".quit") {
            beforeEach {
                presenter.quit()
            }

            it("terminates the app") {
                expect(application.terminateCalled).to(beTrue())
            }
        }

        describe(".showApplicationMenu") {
            beforeEach {
                presenter.showApplicationMenu()
            }

            it("pop ups the menu in user interface") {
                expect(userInterface.popUpOptionsMenuCalled).to(beTrue())
            }
        }

        describe(".didFindNewTestLogFile") {
            beforeEach {
                presenter.didFindNewTestLogFile(at: "/Users/antondomashnev/Library/Xcode/Logs/MyLog.log")
            }

            it("starts listening for snapshot tests results from the given test log") {
                expect(interactor.startSnapshotTestResultListeningCalled).to(beTrue())
                expect(interactor.startSnapshotTestResultListeningReceivedPath).to(equal("/Users/antondomashnev/Library/Xcode/Logs/MyLog.log"))
            }
        }

        describe(".didFindNewTestResult") {
            beforeEach {
                presenter.didFindNewTestResult(SnapshotTestResult.failed(testName: "testName", referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath"))
            }

            it("sets that new test results are available in user interface") {
                expect(userInterface.setNewTestResultsReceivedAvailable).to(beTrue())
                expect(userInterface.setNewTestResultsCalled).to(beTrue())
            }
        }

        describe(".showTestResults") {
            context("when interactor has test results") {
                var foundTestResults: [SnapshotTestResult] = []

                beforeEach {
                    foundTestResults = [SnapshotTestResult.failed(testName: "testName", referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath")]
                    interactor.foundTestResults = foundTestResults
                    presenter.showTestResults()
                }

                it("sets that there no new test results in user interface") {
                    expect(userInterface.setNewTestResultsCalled).to(beTrue())
                    expect(userInterface.setNewTestResultsReceivedAvailable).to(beFalse())
                }

                it("shows test results") {
                    let expectedPaameter = SnapshotTestResult.failed(testName: "testName", referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath")
                    expect(wireframe.showTestResultsModuleCalled).to(beTrue())
                    expect(wireframe.showTestResultsModuleReceivedParameters[0]).to(equal(expectedPaameter))
                }
            }

            context("when interactor doesn't have test result") {
                beforeEach {
                    presenter.showTestResults()
                }

                it("doesn't update user interface") {
                    expect(userInterface.setNewTestResultsCalled).to(beFalse())
                }

                it("doesn't show test results") {
                    expect(wireframe.showTestResultsModuleCalled).to(beFalse())
                }
            }
        }
    }
}
