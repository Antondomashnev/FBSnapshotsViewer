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
    
    // MARK: - Interface
    
    init(applicationNameExtractorFactory: ApplicationNameExtractorFactory = ApplicationNameExtractorFactory()) {
        self.applicationNameExtractorFactory = applicationNameExtractorFactory
    }

    func applicationSnapshotTestResultListener(forLogFileAt path: String, configuration: Configuration = Configuration.default()) -> ApplicationSnapshotTestResultListener {
        let fileWatcher = KZFileWatchers.FileWatcher.Local(path: path)
        let reader = ApplicationLogReader(configuration: configuration)
        let applicationNameExtractor = applicationNameExtractorFactory.applicationNameExtractor(for: configuration)
        return ApplicationSnapshotTestResultListener(fileWatcher: fileWatcher, applicationLogReader: reader, applicationNameExtractor: applicationNameExtractor)
    }
}
