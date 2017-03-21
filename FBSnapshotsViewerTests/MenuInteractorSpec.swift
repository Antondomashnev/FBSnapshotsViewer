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

class MenuInteractor_MockSnapshotsViewerApplicationRunNotificationListener: SnapshotsViewerApplicationRunNotificationListener {

}

class MenuInteractor_MockApplicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder {
    let mockApplicationTemporaryFolder = "simulator/apps/1234-1234-1234-1234/tmp/"
    var checkingSimulatorPath: String!
    var output: ApplicationTemporaryFolderFinderOutput!

    override func find(in simulatorPath: String, outputTo completion: @escaping ApplicationTemporaryFolderFinderOutput) {
        output = completion
        checkingSimulatorPath = simulatorPath
    }
}

class MenuInteractor_MockApplicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener {
    var output: ApplicationSnapshotTestResultListenerOutput!
    var listeningApplication: Application!

    override func listen(application: Application, outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        listeningApplication = application
        output = completion
    }
}

class MenuInteractorSpec: QuickSpec {
    override func spec() {
        var output: MenuInteractorOutputMock!
        var interactor: MenuInteractor!
        var snaphotsDiffFolderNotificationListener: MenuInteractor_MockSnapshotsViewerApplicationRunNotificationListener!
        var applicationTemporaryFolderFinder: MenuInteractor_MockApplicationTemporaryFolderFinder!
        var applicationSnapshotTestResultListener: MenuInteractor_MockApplicationSnapshotTestResultListener!

        beforeEach {
            output = MenuInteractorOutputMock()
            snaphotsDiffFolderNotificationListener = MenuInteractor_MockSnapshotsViewerApplicationRunNotificationListener()
            applicationTemporaryFolderFinder = MenuInteractor_MockApplicationTemporaryFolderFinder()
            applicationSnapshotTestResultListener = MenuInteractor_MockApplicationSnapshotTestResultListener()
            interactor = MenuInteractor(snaphotsDiffFolderNotificationListener: snaphotsDiffFolderNotificationListener,
                                        applicationTemporaryFolderFinder: applicationTemporaryFolderFinder,
                                        applicationSnapshotTestResultListener: applicationSnapshotTestResultListener)
            interactor.output = output
        }

        describe(".foundTestResults") {
            let testResult1 = CompletedTestResult(referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", testName: "testName1")
            let testResult2 = CompletedTestResult(referenceImagePath: "referenceImagePath2", diffImagePath: "diffImagePath2", failedImagePath: "failedImagePath2", testName: "testName2")

            beforeEach {
                snaphotsDiffFolderNotificationListener.delegate?.snapshotsDiffFolderNotificationListener(snaphotsDiffFolderNotificationListener, didReceiveRunningiOSSimulatorFolder: "simulator/blabla", andImageDiffFolder: "my_image_diff_folder/")
                applicationSnapshotTestResultListener.output(testResult1)
                applicationSnapshotTestResultListener.output(testResult2)
            }

            it("is the collection of all found test result") {
                expect(interactor.foundTestResults.contains(where: { $0 == testResult1 })).to(beTrue())
                expect(interactor.foundTestResults.contains(where: { $0 == testResult2 })).to(beTrue())
            }

            context("when received running tests notification") {
                beforeEach {
                    snaphotsDiffFolderNotificationListener.delegate?.snapshotsDiffFolderNotificationListener(snaphotsDiffFolderNotificationListener, didReceiveRunningiOSSimulatorFolder: "simulator/foobar", andImageDiffFolder: "my_image_diff_folder/")
                }

                it("cleans the collection") {
                    expect(interactor.foundTestResults.isEmpty).to(beTrue())
                }
            }
        }

        context("when receives notification from running tests in specific folder") {
            beforeEach {
                snaphotsDiffFolderNotificationListener.delegate?.snapshotsDiffFolderNotificationListener(snaphotsDiffFolderNotificationListener, didReceiveRunningiOSSimulatorFolder: "simulator/blabla", andImageDiffFolder: "my_image_diff_folder/")
            }

            it("starts looking for test results for correct application") {
                expect(applicationSnapshotTestResultListener.listeningApplication.snapshotsDiffFolder).to(equal("my_image_diff_folder/"))
            }

            context("when test results listener finds new test result") {
                var testResult: TestResult!

                beforeEach {
                    testResult = CompletedTestResult(referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", testName: "testName")
                    applicationSnapshotTestResultListener.output(testResult)
                }

                it("outputs found test result") {
                    expect(output.didFindReceivedTestResult?.referenceImagePath).to(equal(testResult.referenceImagePath))
                    expect(output.didFindReceivedTestResult?.failedImagePath).to(equal(testResult.failedImagePath))
                    expect(output.didFindReceivedTestResult?.diffImagePath).to(equal(testResult.diffImagePath))
                    expect(output.didFindReceivedTestResult?.testName).to(equal(testResult.testName))
                }
            }
        }

        context("when receives notification from running tests without specific folder") {
            beforeEach {
                snaphotsDiffFolderNotificationListener.delegate?.snapshotsDiffFolderNotificationListener(snaphotsDiffFolderNotificationListener, didReceiveRunningiOSSimulatorFolder: "simulator/apps/", andImageDiffFolder: nil)
            }

            it("starts finding running application temporary folder for correct simulator") {
                expect(applicationTemporaryFolderFinder.checkingSimulatorPath).to(equal("simulator/apps/"))
            }

            context("when temporary folder finder finds diff folder") {
                beforeEach {
                    applicationTemporaryFolderFinder.output(applicationTemporaryFolderFinder.mockApplicationTemporaryFolder)
                }

                it("starts looking for test results for correct application") {
                    expect(applicationSnapshotTestResultListener.listeningApplication.snapshotsDiffFolder).to(equal(applicationTemporaryFolderFinder.mockApplicationTemporaryFolder))
                }

                context("when test results listener finds new test result") {
                    var testResult: TestResult!

                    beforeEach {
                        testResult = CompletedTestResult(referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", testName: "testName")
                        applicationSnapshotTestResultListener.output(testResult)
                    }

                    it("outputs found test result") {
                        expect(output.didFindReceivedTestResult?.referenceImagePath).to(equal(testResult.referenceImagePath))
                        expect(output.didFindReceivedTestResult?.failedImagePath).to(equal(testResult.failedImagePath))
                        expect(output.didFindReceivedTestResult?.diffImagePath).to(equal(testResult.diffImagePath))
                        expect(output.didFindReceivedTestResult?.testName).to(equal(testResult.testName))
                    }
                }
            }
        }
    }
}
