//
//  ApplicationSnapshotTestResultListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 25/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

typealias ApplicationSnapshotTestResultListenerOutput = (SnapshotTestResult) -> Void

struct ApplicationSnapshotTestResultListenerAction {
    let output: ApplicationSnapshotTestResultListenerOutput
    let folderEventsListener: FolderEventsListener
    let application: Application

    func run() {
        folderEventsListener.startListening()
    }

    func stop() {
        folderEventsListener.stopListening()
    }
}

class ApplicationSnapshotTestResultListener {
    fileprivate var runningAction: ApplicationSnapshotTestResultListenerAction?

    init() {
    }

    deinit {
        resetRunningAction()
    }

    func listen(logFileAt logFilePath: String, outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        resetRunningAction()
//        var folderEventsListener = folderEventsListenerFactory.snapshotsDiffFolderEventsListener(at: application.snapshotsDiffFolder)
//        folderEventsListener.output = self
//        let snapshotTestImagesCollector = snapshotTestImagesCollectorFactory.applicationSnapshotTestImageCollector()
//        snapshotTestImagesCollector.output = self
//        runningAction = ApplicationSnapshotTestResultListenerAction(output: completion, folderEventsListener: folderEventsListener, snapshotTestImagesCollector: snapshotTestImagesCollector, application: application)
//        runningAction?.run()
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

// MARK: - FolderEventsListenerOutput
extension ApplicationSnapshotTestResultListener: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
    }
}
