//
//  MenuInteractorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import KZFileWatchers

@testable import FBSnapshotsViewer

class MenuInteractor_MockApplicationSnapshotTestResultListenerFactory: ApplicationSnapshotTestResultListenerFactory {
    var mockApplicationSnapshotTestResultListener: MenuInteractor_MockApplicationSnapshotTestResultListener!
    var givenLogFilePath: String!

    override func applicationSnapshotTestResultListener(forLogFileAt path: String) -> ApplicationSnapshotTestResultListener {
        givenLogFilePath = path
        return mockApplicationSnapshotTestResultListener
    }
}

class MenuInteractor_MockApplicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener {
    var output: ApplicationSnapshotTestResultListenerOutput!

    override func startListening(outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
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
        let testResult1 = SnapshotTestResult.failed(testName: "testName1", referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1")
        let testResult2 = SnapshotTestResult.failed(testName: "testName2", referenceImagePath: "referenceImagePath2", diffImagePath: "diffImagePath2", failedImagePath: "failedImagePath2")
        let testResult3 = SnapshotTestResult.recorded(testName: "testName3", referenceImagePath: "referenceImagePath3")

        var output: MenuInteractorOutputMock!
        var interactor: MenuInteractor!
        var applicationSnapshotTestResultListener: MenuInteractor_MockApplicationSnapshotTestResultListener!
        var applicationSnapshotTestResultListenerFactory: MenuInteractor_MockApplicationSnapshotTestResultListenerFactory!
        var applicationTestLogFilesListener: MenuInteractor_MockApplicationTestLogFilesListener!

        beforeEach {
            output = MenuInteractorOutputMock()
            applicationSnapshotTestResultListener = MenuInteractor_MockApplicationSnapshotTestResultListener(fileWatcher: KZFileWatchers.FileWatcher.Local(path: "testpath"))
            applicationSnapshotTestResultListenerFactory = MenuInteractor_MockApplicationSnapshotTestResultListenerFactory()
            applicationSnapshotTestResultListenerFactory.mockApplicationSnapshotTestResultListener = applicationSnapshotTestResultListener
            applicationTestLogFilesListener = MenuInteractor_MockApplicationTestLogFilesListener()
            interactor = MenuInteractor(applicationSnapshotTestResultListenerFactory: applicationSnapshotTestResultListenerFactory, applicationTestLogFilesListener: applicationTestLogFilesListener)
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
            context("when start listening unique log file path") {
                beforeEach {
                    interactor.startSnapshotTestResultListening(fromLogFileAt: "/Users/antondomashnev/Library/Bla/Bla.log")
                }

                it("creates listener for correct log file path") {
                    expect(applicationSnapshotTestResultListenerFactory.givenLogFilePath).to(equal("/Users/antondomashnev/Library/Bla/Bla.log"))
                }

                context("when find new test result") {
                    beforeEach {
                        applicationSnapshotTestResultListener.output(testResult1)
                    }

                    it("outputs it") {
                        let expectedTestResult = SnapshotTestResult.failed(testName: "testName1", referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1")
                        expect(output.didFindNewTestResultReceivedTestResult).to(equal(expectedTestResult))
                    }
                }

                context("when find three test results consequently") {
                    beforeEach {
                        applicationSnapshotTestResultListener.output(testResult1)
                        applicationSnapshotTestResultListener.output(testResult2)
                        applicationSnapshotTestResultListener.output(testResult3)
                    }

                    it("stores all of them") {
                        expect(interactor.foundTestResults.contains(where: { $0 == testResult1 })).to(beTrue())
                        expect(interactor.foundTestResults.contains(where: { $0 == testResult2 })).to(beTrue())
                        expect(interactor.foundTestResults.contains(where: { $0 == testResult3 })).to(beTrue())
                    }
                }
            }

            context("when start listening already listened log file path") {
                beforeEach {
                    interactor.startSnapshotTestResultListening(fromLogFileAt: "/Users/antondomashnev/Library/Bla/Bla1.log")
                    interactor.startSnapshotTestResultListening(fromLogFileAt: "/Users/antondomashnev/Library/Bla/Bla2.log")
                    interactor.startSnapshotTestResultListening(fromLogFileAt: "/Users/antondomashnev/Library/Bla/Bla1.log")
                }

                it("doesnt create duplicate listener") {
                    expect(applicationSnapshotTestResultListenerFactory.givenLogFilePath).to(equal("/Users/antondomashnev/Library/Bla/Bla2.log"))
                }
            }
        }
    }
}
