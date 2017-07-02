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
    var givenConfiguration: FBSnapshotsViewer.Configuration!

    override func applicationSnapshotTestResultListener(forLogFileAt path: String, configuration: FBSnapshotsViewer.Configuration) -> ApplicationSnapshotTestResultListener {
        givenLogFilePath = path
        givenConfiguration = configuration
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
    var listeningDerivedDataFolder: DerivedDataFolder!
    var stopListeningCalled: Bool = false

    override func listen(derivedDataFolder: DerivedDataFolder, outputTo completion: @escaping ApplicationTestLogFilesListenerOutput) {
        listeningDerivedDataFolder = derivedDataFolder
        output = completion
    }

    override func stopListening() {
        stopListeningCalled = true
    }
}

class MenuInteractorSpec: QuickSpec {
    override func spec() {
        let testResultsDate = Date()
        let applicationName = "FBSnapshotsViewer"
        let fbReferenceImageDirURL = URL(fileURLWithPath: "foo/bar", isDirectory: true)
        let build = Build(date: testResultsDate, applicationName: applicationName, fbReferenceImageDirectoryURL: fbReferenceImageDirURL)
        let testResult1 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClass1", testName: "testName1"), referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", build: build)
        let testResult2 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClass2", testName: "testName2"), referenceImagePath: "referenceImagePath2", diffImagePath: "diffImagePath2", failedImagePath: "failedImagePath2", build: build)
        let testResult3 = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClass3", testName: "testName3"), referenceImagePath: "referenceImagePath3", build: build)
        
        var configuration: FBSnapshotsViewer.Configuration!
        var output: MenuInteractorOutputMock!
        var interactor: MenuInteractor!
        var applicationSnapshotTestResultListener: MenuInteractor_MockApplicationSnapshotTestResultListener!
        var applicationSnapshotTestResultListenerFactory: MenuInteractor_MockApplicationSnapshotTestResultListenerFactory!
        var applicationTestLogFilesListener: MenuInteractor_MockApplicationTestLogFilesListener!

        beforeEach {
            configuration = Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
            output = MenuInteractorOutputMock()
            applicationSnapshotTestResultListener = MenuInteractor_MockApplicationSnapshotTestResultListener(fileWatcher: KZFileWatchers.FileWatcher.Local(path: "testpath"), fileWatcherUpdateHandler: ApplicationSnapshotTestResultFileWatcherUpdateHandler())
            applicationSnapshotTestResultListenerFactory = MenuInteractor_MockApplicationSnapshotTestResultListenerFactory()
            applicationSnapshotTestResultListenerFactory.mockApplicationSnapshotTestResultListener = applicationSnapshotTestResultListener
            applicationTestLogFilesListener = MenuInteractor_MockApplicationTestLogFilesListener()
            interactor = MenuInteractor(applicationSnapshotTestResultListenerFactory: applicationSnapshotTestResultListenerFactory, applicationTestLogFilesListener: applicationTestLogFilesListener, configuration: configuration)
            interactor.output = output
        }

        describe(".startXcodeBuildsListening") {
            beforeEach {
                interactor.startXcodeBuildsListening(derivedDataFolder: DerivedDataFolder.xcodeCustom(path: "/Users/antondomashnev/Library/Bla"))
            }

            it("stops the current xcodeDefault builds listening") {
                expect(applicationTestLogFilesListener.stopListeningCalled).to(beTrue())
            }

            it("starts a new listening of the given derived data folder") {
                let expectedDerivedDataFolder = DerivedDataFolder.xcodeCustom(path: "/Users/antondomashnev/Library/Bla")
                expect(applicationTestLogFilesListener.listeningDerivedDataFolder).to(equal(expectedDerivedDataFolder))
            }

            context("when find a new test log file") {
                beforeEach {
                    applicationTestLogFilesListener.output("/Users/antondomashnev/Library/Bla/Bla.log")
                }

                it("outputs it") {
                    expect(output.didFindNewTestLogFile_at_Called).to(beTrue())
                    expect(output.didFindNewTestLogFile_at_ReceivedPath).to(equal("/Users/antondomashnev/Library/Bla/Bla.log"))
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
                
                it("creates listener with correct configuration") {
                    expect(applicationSnapshotTestResultListenerFactory.givenConfiguration).to(equal(configuration))
                }

                context("when find new test result") {
                    beforeEach {
                        applicationSnapshotTestResultListener.output(testResult1)
                    }

                    it("outputs it") {
                        let build = Build(date: testResultsDate, applicationName: applicationName, fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
                        let expectedTestResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClass1", testName: "testName1"), referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", build: build)
                        expect(output.didFindNewTestResult___ReceivedTestResult).to(equal(expectedTestResult))
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
