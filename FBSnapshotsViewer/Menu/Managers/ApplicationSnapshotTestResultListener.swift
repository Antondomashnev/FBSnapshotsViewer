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
    fileprivate var runningAction: ApplicationSnapshotTestResultListenerAction?
    
    init(folderEventsListenerFactory: FolderEventsListenerFactory = FolderEventsListenerFactory()) {
        self.folderEventsListenerFactory = folderEventsListenerFactory
    }
    
    deinit {
        resetRunningAction()
    }
    
    func listen(application: Application, outputTo completion: @escaping ApplicationSnapshotTestResultListenerOutput) {
        resetRunningAction()
        var folderEventsListener = folderEventsListenerFactory.snapshotsDiffFolderEventsListener(at: application.snapshotsDiffFolder)
        folderEventsListener.output = self
        runningAction = ApplicationSnapshotTestResultListenerAction(output: completion, folderEventsListener: folderEventsListener, application: application)
        runningAction?.run()
    }
    
    // MARK: - Helpers
    
    func resetRunningAction() {
        runningAction?.stop()
        runningAction = nil
    }
}

// MARK: - FolderEventsListenerOutput
extension ApplicationSnapshotTestResultListener: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive event: FolderEvent) {
        print("did receive event: \(event)")
    }
}
