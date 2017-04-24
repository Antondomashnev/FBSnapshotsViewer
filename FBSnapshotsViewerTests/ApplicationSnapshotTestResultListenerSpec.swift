////
////  ApplicationSnapshotTestResultListenerSpec.swift
////  FBSnapshotsViewer
////
////  Created by Anton Domashnev on 11/03/2017.
////  Copyright © 2017 Anton Domashnev. All rights reserved.
////
//
//import Quick
//import Nimble
//
//@testable import FBSnapshotsViewer
//
//class ApplicationSnapshotTestResultListener_MockFolderEventsListener: FolderEventsListener {
//    weak var output: FolderEventsListenerOutput?
//
//    required init(folderPath: String, filter: FolderEventFilter? = nil, fileWatcherFactory: FileWatcherFactory = FileWatcherFactory()) {}
//
//    func startListening() {}
//
//    func stopListening() {}
//}
//
//class ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestImageCollector: ApplicationSnapshotTestImageCollector {
//    var collectCalled: Bool = false
//
//    override func collect(_ testImage: SnapshotTestImage) {
//        collectCalled = true
//    }
//}
//
//class ApplicationSnapshotTestResultListener_MockFolderEventsListenerFactory: FolderEventsListenerFactory {
//    var mockSnapshotsDiffFolderEventsListener: ApplicationSnapshotTestResultListener_MockFolderEventsListener!
//
//    override func snapshotsDiffFolderEventsListener(at folderPath: String) -> FolderEventsListener {
//        return mockSnapshotsDiffFolderEventsListener
//    }
//}
//
//class ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestImageCollectorFactory: ApplicationSnapshotTestImageCollectorFactory {
//    var mockApplicationSnapshotTestImageCollector: ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestImageCollector!
//
//    override func applicationSnapshotTestImageCollector() -> ApplicationSnapshotTestImageCollector {
//        return mockApplicationSnapshotTestImageCollector
//    }
//}
//
//class ApplicationSnapshotTestResultListenerSpec: QuickSpec {
//    override func spec() {
//        var outputtedTestResult: TestResult?
//        var output: ApplicationSnapshotTestResultListenerOutput!
//        var snapshotTestResultListener: ApplicationSnapshotTestResultListener!
//        var folderEventsListenerFactory: ApplicationSnapshotTestResultListener_MockFolderEventsListenerFactory!
//        var snapshotTestImagesCollectorFactory: ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestImageCollectorFactory!
//
//        func mockOutput(testResult: TestResult) {
//            outputtedTestResult = testResult
//        }
//
//        beforeEach {
//            output = mockOutput
//            folderEventsListenerFactory = ApplicationSnapshotTestResultListener_MockFolderEventsListenerFactory()
//            snapshotTestImagesCollectorFactory = ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestImageCollectorFactory()
//            snapshotTestResultListener = ApplicationSnapshotTestResultListener(folderEventsListenerFactory: folderEventsListenerFactory, snapshotTestImagesCollectorFactory: snapshotTestImagesCollectorFactory)
//        }
//
//        describe(".listen") {
//            beforeEach {
//                folderEventsListenerFactory.mockSnapshotsDiffFolderEventsListener = ApplicationSnapshotTestResultListener_MockFolderEventsListener(folderPath: "")
//                snapshotTestImagesCollectorFactory.mockApplicationSnapshotTestImageCollector = ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestImageCollector()
//                snapshotTestResultListener.listen(application: Application(snapshotsDiffFolder: "myDiffFolder"), outputTo: output)
//            }
//
//            context("when folder listener receives event") {
//                context("when event is test image event") {
//                    beforeEach {
//                        folderEventsListenerFactory.mockSnapshotsDiffFolderEventsListener.output?.folderEventsListener(folderEventsListenerFactory.mockSnapshotsDiffFolderEventsListener, didReceive: FolderEvent.created(path: "reference_image.png", object: .file))
//                    }
//
//                    it("collects it") {
//                        expect(snapshotTestImagesCollectorFactory.mockApplicationSnapshotTestImageCollector.collectCalled).to(beTrue())
//                    }
//
//                    context("when collector outputs the collected test result") {
//                        let collectedTestResult = CompletedTestResult(referenceImagePath: "referenceImagePath", diffImagePath: "diffImagePath", failedImagePath: "failedImagePath", testName: "testName")
//
//                        beforeEach {
//                            snapshotTestImagesCollectorFactory.mockApplicationSnapshotTestImageCollector.output?.applicationSnapshotTestResultCollector(snapshotTestImagesCollectorFactory.mockApplicationSnapshotTestImageCollector, didCollect: collectedTestResult)
//                        }
//
//                        it("outputs it") {
//                            expect(outputtedTestResult?.referenceImagePath).to(equal(collectedTestResult.referenceImagePath))
//                            expect(outputtedTestResult?.diffImagePath).to(equal(collectedTestResult.diffImagePath))
//                            expect(outputtedTestResult?.failedImagePath).to(equal(collectedTestResult.failedImagePath))
//                            expect(outputtedTestResult?.testName).to(equal(collectedTestResult.testName))
//                        }
//                    }
//                }
//
//                context("when event us not a test image event") {
//                    beforeEach {
//                        folderEventsListenerFactory.mockSnapshotsDiffFolderEventsListener.output?.folderEventsListener(folderEventsListenerFactory.mockSnapshotsDiffFolderEventsListener, didReceive: FolderEvent.created(path: "image.png", object: .file))
//                    }
//
//                    it("ignores is") {
//                        expect(snapshotTestImagesCollectorFactory.mockApplicationSnapshotTestImageCollector.collectCalled).to(beFalse())
//                    }
//                }
//            }
//        }
//    }
//}
