//
//  ApplicationSnapshotTestResultListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

typealias ApplicationSnapshotTestResultListenerOutput = (TestResult) -> Void

struct ApplicationSnapshotTestResultListenerAction {
    let output: ApplicationSnapshotTestResultListenerOutput
    let folderEventsListener: FolderEventsListener
    let snapshotTestImagesCollector: ApplicationSnapshotTestImageCollector
    let application: Application

    func run() {
        folderEventsListener.startListening()
    }

    func stop() {
        folderEventsListener.stopListening()
    }
}

class ApplicationSnapshotTestResultListener {
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    fileprivate let snapshotTestImagesCollectorFactory: ApplicationSnapshotTestImageCollectorFactory
    fileprivate var runningAction: ApplicationSnapshotTestResultListenerAction?

    init(folderEventsListenerFactory: FolderEventsListenerFactory = FolderEventsListenerFactory(), snapshotTestImagesCollectorFactory: ApplicationSnapshotTestImageCollectorFactory = ApplicationSnapshotTestImageCollectorFactory()) {
        self.folderEventsListenerFactory = folderEventsListenerFactory
        self.snapshotTestImagesCollectorFactory = snapshotTestImagesCollectorFactory
    }

    deinit {
        resetRunningAction()
    }

    func listen(application: Application, outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        resetRunningAction()
        var folderEventsListener = folderEventsListenerFactory.snapshotsDiffFolderEventsListener(at: application.snapshotsDiffFolder)
        folderEventsListener.output = self
        let snapshotTestImagesCollector = snapshotTestImagesCollectorFactory.applicationSnapshotTestImageCollector()
        snapshotTestImagesCollector.output = self
        runningAction = ApplicationSnapshotTestResultListenerAction(output: completion, folderEventsListener: folderEventsListener, snapshotTestImagesCollector: snapshotTestImagesCollector, application: application)
        runningAction?.run()
    }

    func stopListening() {
        resetRunningAction()
    }

    // MARK: - Helpers

    private func resetRunningAction() {
        runningAction?.stop()
        runningAction = nil
    }
}

// MARK: - ApplicationSnapshotTestImageCollectorOutput

extension ApplicationSnapshotTestResultListener: ApplicationSnapshotTestImageCollectorOutput {
    func applicationSnapshotTestResultCollector(_ collector: ApplicationSnapshotTestImageCollector, didCollect testResult: TestResult) {
        runningAction?.output(testResult)
    }
}

// MARK: - FolderEventsListenerOutput
extension ApplicationSnapshotTestResultListener: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        guard let eventPath = event.path, let snapshotTestImage = SnapshotTestImage(imagePath: eventPath) else {
            print("Unexpected event in ApplicationSnapshotTestResultListener: \(event)")
            return
        }
        runningAction?.snapshotTestImagesCollector.collect(snapshotTestImage)
    }
}
