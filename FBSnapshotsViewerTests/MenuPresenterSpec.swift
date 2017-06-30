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

    var showPreferencesModuleCalled: Bool = false
    override func showPreferencesModule(with configurationStorage: ConfigurationStorage) {
        showPreferencesModuleCalled = true
    }
}

class MenuPresenterSpec: QuickSpec {
    override func spec() {
        var build: Build!
        var configuration: FBSnapshotsViewer.Configuration!
        var derivedDataFolder: DerivedDataFolder!
        var application: ApplicationMock!
        var userInterface: MenuUserInterfaceMock!
        var presenter: MenuPresenter!
        var interactor: MenuInteractorInputMock!
        var wireframe: MenuPresenter_MockMenuWireframe!
        var updater: UpdaterMock!

        beforeEach {
            build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
            updater = UpdaterMock()
            derivedDataFolder = DerivedDataFolder.xcodeCustom(path: "Users/antondomashnev/Library/Xcode/temporaryFolder")
            configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: derivedDataFolder)
            application = ApplicationMock()
            wireframe = MenuPresenter_MockMenuWireframe()
            interactor = MenuInteractorInputMock()
            presenter = MenuPresenter(configuration: configuration, application: application, updater: updater)
            userInterface = MenuUserInterfaceMock()
            presenter.userInterface = userInterface
            presenter.interactor = interactor
            presenter.wireframe = wireframe
        }

        describe(".checkForUpdates") {
            beforeEach {
                presenter.checkForUpdates()
            }

            it("checks for updaters") {
                expect(updater.checkForUpdates_Called).to(beTrue())
            }
        }

        describe(".showPreferences") {
            beforeEach {
                presenter.showPreferences()
            }

            it("shows preferences") {
                expect(wireframe.showPreferencesModuleCalled).to(beTrue())
            }
        }

        describe(".start") {
            beforeEach {
                presenter.start()
            }

            it("starts the Xcode builds listening") {
                expect(interactor.startXcodeBuildsListening_derivedDataFolder_ReceivedDerivedDataFolder).to(equal(derivedDataFolder))
            }
        }

        describe(".quit") {
            beforeEach {
                presenter.quit()
            }

            it("terminates the app") {
                expect(application.terminate___Called).to(beTrue())
            }
        }

        describe(".showApplicationMenu") {
            beforeEach {
                presenter.showApplicationMenu()
            }

            it("pop ups the menu in user interface") {
                expect(userInterface.popUpOptionsMenu_Called).to(beTrue())
            }
        }

        describe(".didFindNewTestLogFile") {
            beforeEach {
                presenter.didFindNewTestLogFile(at: "/Users/antondomashnev/Library/Xcode/Logs/MyLog.log")
            }

            it("starts listening for snapshot tests results from the given test log") {
                expect(interactor.startSnapshotTestResultListening_fromLogFileAt_Called).to(beTrue())
                expect(interactor.startSnapshotTestResultListening_fromLogFileAt_ReceivedPath).to(equal("/Users/antondomashnev/Library/Xcode/Logs/MyLog.log"))
            }
        }

        describe(".didFindNewTestResult") {
            beforeEach {
                presenter.didFindNewTestResult(SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build))
            }

            it("sets that new test results are available in user interface") {
                expect(userInterface.setNewTestResults_available_Called).to(beTrue())
                expect(userInterface.setNewTestResults_available_ReceivedAvailable).to(beTrue())
            }
        }

        describe(".showTestResults") {
            context("when interactor has test results") {
                var foundTestResults: [SnapshotTestResult] = []

                beforeEach {
                    foundTestResults = [SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)]
                    interactor.foundTestResults = foundTestResults
                    presenter.showTestResults()
                }

                it("sets that there no new test results in user interface") {
                    expect(userInterface.setNewTestResults_available_Called).to(beTrue())
                    expect(userInterface.setNewTestResults_available_ReceivedAvailable).to(beFalse())
                }

                it("shows test results") {
                    let expectedPaameter = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", build: build)
                    expect(wireframe.showTestResultsModuleCalled).to(beTrue())
                    expect(wireframe.showTestResultsModuleReceivedParameters[0]).to(equal(expectedPaameter))
                }
            }

            context("when interactor doesn't have test result") {
                beforeEach {
                    presenter.showTestResults()
                }

                it("doesn't update user interface") {
                    expect(userInterface.setNewTestResults_available_Called).to(beFalse())
                }

                it("doesn't show test results") {
                    expect(wireframe.showTestResultsModuleCalled).to(beFalse())
                }
            }
        }
    }
}
