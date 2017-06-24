//
//  ApplicationSnapshotTestResultListenerFactory.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import KZFileWatchers

class ApplicationSnapshotTestResultListenerFactory {
    private let applicationNameExtractorFactory: ApplicationNameExtractorFactory
    private let fbReferenceImageDirExtractorFactory: FBReferenceImageDirectoryURLExtractorFactory
    
    // MARK: - Interface
    
    init(applicationNameExtractorFactory: ApplicationNameExtractorFactory = ApplicationNameExtractorFactory(), fbReferenceImageDirExtractorFactory: FBReferenceImageDirectoryURLExtractorFactory = FBReferenceImageDirectoryURLExtractorFactory()) {
        self.applicationNameExtractorFactory = applicationNameExtractorFactory
        self.fbReferenceImageDirExtractorFactory = fbReferenceImageDirExtractorFactory
    }

    func applicationSnapshotTestResultListener(forLogFileAt path: String, configuration: Configuration = Configuration.default()) -> ApplicationSnapshotTestResultListener {
        let fileWatcher = KZFileWatchers.FileWatcher.Local(path: path)
        let reader = ApplicationLogReader(configuration: configuration)
        let applicationNameExtractor = applicationNameExtractorFactory.applicationNameExtractor(for: configuration)
        let imageDirectoryExtractor = fbReferenceImageDirExtractorFactory.fbReferenceImageDirectoryURLExtractor(for: configuration)
        let applicationSnapshotTestResultFileWatcherUpdateHandler = ApplicationSnapshotTestResultFileWatcherUpdateHandler(applicationLogReader: reader, applicationNameExtractor: applicationNameExtractor, fbImageReferenceDirExtractor: imageDirectoryExtractor)
        return ApplicationSnapshotTestResultListener(fileWatcher: fileWatcher, fileWatcherUpdateHandler: applicationSnapshotTestResultFileWatcherUpdateHandler)
    }
}
