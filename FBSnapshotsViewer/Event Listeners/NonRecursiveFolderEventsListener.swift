//
//  NonRecursiveFolderEventsListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import SwiftFSWatcher

/// `NonRecursiveFolderEventsListener` is responsible to watch folder
///  changes (new file, updated file, deleted file), watches only the given folder non-recursively.
///  It uses the 3rd party dependency under the hood.
final class NonRecursiveFolderEventsListener: FolderEventsListener {
    
    /// Internal 3rd party watcher
    fileprivate let watcher: SwiftFSWatcher
    
    /// Applied filter for watched events
    fileprivate let filter: FolderEventFilter?
    
    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?
    
    init(folderPath: String, filter: FolderEventFilter? = nil) {
        self.filter = filter
        watcher = SwiftFSWatcher([folderPath])
    }
    
    func startListening() {
        watcher.watch { [weak self] events in
            guard let strongSelf = self else {
                return
            }
            let receivedEvents: [FolderEvent] = events.map { FolderEvent(systemEvents: $0.eventFlag.intValue, at: $0.eventPath) }
            strongSelf.output?.folderEventsListener(strongSelf, didReceive: receivedEvents)
        }
    }
    
    func stopListening() {
        watcher.pause()
    }
}
