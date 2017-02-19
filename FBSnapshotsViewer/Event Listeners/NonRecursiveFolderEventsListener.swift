//
//  NonRecursiveFolderEventsListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// `NonRecursiveFolderEventsListener` is responsible to watch folder
///  changes (new file, updated file, deleted file), watches only the given folder non-recursively.
///  It uses the 3rd party dependency under the hood.
final class NonRecursiveFolderEventsListener: FolderEventsListener {
    
    /// Internal 3rd party watcher
    fileprivate var watcher: FileWatch?
    
    /// Applied filter for watched events
    fileprivate let filter: FolderEventFilter?
    
    /// Currently watching folder path
    let folderPath: String
    
    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?
    
    init(folderPath: String, filter: FolderEventFilter? = nil) {
        self.filter = filter
        self.folderPath = folderPath
    }
    
    func startListening() {
        watcher = try? FileWatch(paths: [folderPath], createFlag: [.UseCFTypes, .FileEvents], runLoop: RunLoop.current, latency: 1) { [weak self] event in
            guard let strongSelf = self else {
                return
            }
            let folderEvent = FolderEvent(eventFlag: event.flag, at: event.path)
            if let existedFilter = strongSelf.filter, !existedFilter.apply(to: folderEvent) {
                return
            }
            strongSelf.output?.folderEventsListener(strongSelf, didReceive: folderEvent)
        }
    }
    
    func stopListening() {
        watcher = nil
    }
}
