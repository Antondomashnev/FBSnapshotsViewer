//
//  MenuInteractorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class MenuInteractor_MockApplicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener {
    var output: ApplicationSnapshotTestResultListenerOutput!
    var listeningLogFilePath: String!

    override func listen(logFileAt path: String, outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        listeningLogFilePath = path
        output = completion
    }
}

class MenuInteractor_MockApplicationTestLogFilesListener: ApplicationTestLogFilesListener {
    var output: ApplicationTestLogFilesListenerOutput!
    var listeningDerivedDataFolder: String!
    var stopListeningCalled: Bool = false

    override func listen(xcodeDerivedDataFolder: String, outputTo completion: @escaping ApplicationTestLogFilesListenerOutput) {
        listeningDerivedDataFolder = xcodeDerivedDataFolder
        output = completion
    }

    override func stopListening() {
        stopListeningCalled = true
    }
}

class MenuInteractorSpec: QuickSpec {
    override func spec() {
        let testResult1 = CompletedTestResult(referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", testName: "testName1")
        let testResult2 = CompletedTestResult(referenceImagePath: "referenceImagePath2", diffImagePath: "diffImagePath2", failedImagePath: "failedImagePath2", testName: "testName2")

        var output: MenuInteractorOutputMock!
        var interactor: MenuInteractor!
        var applicationSnapshotTestResultListener: MenuInteractor_MockApplicationSnapshotTestResultListener!
        var applicationTestLogFilesListener: MenuInteractor_MockApplicationTestLogFilesListener!

        beforeEach {
            output = MenuInteractorOutputMock()
            applicationSnapshotTestResultListener = MenuInteractor_MockApplicationSnapshotTestResultListener()
            applicationTestLogFilesListener = MenuInteractor_MockApplicationTestLogFilesListener()
            interactor = MenuInteractor(applicationSnapshotTestResultListener: applicationSnapshotTestResultListener,
                                        applicationTestLogFilesListener: applicationTestLogFilesListener)
            interactor.output = output
        }

        describe(".startXcodeBuildsListening") {
            beforeEach {
                interactor.startXcodeBuildsListening(xcodeDerivedDataFolder: XcodeDerivedDataFolder(path: "/Users/antondomashnev/Library/Bla"))
            }

            it("stops the current xcode builds listening") {
                expect(applicationTestLogFilesListener.stopListeningCalled).to(beTrue())
            }

            it("starts a new listening of the given derived data folder") {
                expect(applicationTestLogFilesListener.listeningDerivedDataFolder).to(equal("/Users/antondomashnev/Library/Bla"))
            }

            context("when find a new test log file") {
                beforeEach {
                    applicationTestLogFilesListener.output("/Users/antondomashnev/Library/Bla/Bla.log")
                }

                it("outputs it") {
                    expect(output.didFindNewTestLogFileCalled).to(beTrue())
                    expect(output.didFindNewTestLogFileReceivedPath).to(equal("/Users/antondomashnev/Library/Bla/Bla.log"))
                }
            }
        }

        describe(".startSnapshotTestResultListening") {
            beforeEach {
                interactor.startSnapshotTestResultListening(fromLogFileAt: "/Users/antondomashnev/Library/Bla/Bla.log")
            }

            context("when find new test result") {
                beforeEach {
                    applicationSnapshotTestResultListener.output(testResult1)
                }

                it("outputs it") {
                    expect(output.didFindNewTestResultReceivedTestResult?.diffImagePath).to(equal("diffImagePath1"))
                    expect(output.didFindNewTestResultReceivedTestResult?.referenceImagePath).to(equal("referenceImagePath1"))
                    expect(output.didFindNewTestResultReceivedTestResult?.failedImagePath).to(equal("failedImagePath1"))
                    expect(output.didFindNewTestResultReceivedTestResult?.testName).to(equal("testName1"))
                }
            }

            context("when find two test results consequently") {
                beforeEach {
                    applicationSnapshotTestResultListener.output(testResult1)
                    applicationSnapshotTestResultListener.output(testResult2)
                }

                it("is the collection of all found test result") {
                    expect(interactor.foundTestResults.contains(where: { $0 == testResult1 })).to(beTrue())
                    expect(interactor.foundTestResults.contains(where: { $0 == testResult2 })).to(beTrue())
                }
            }
        }
    }
}
