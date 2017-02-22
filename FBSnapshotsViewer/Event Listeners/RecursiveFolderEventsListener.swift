//
//  RecursiveFolderEventsListener.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// `NonRecursiveFolderEventsListener` is responsible to watch folder
///  changes (new file, updated file, deleted file), watches only the given folder recursively.
///  It uses the 3rd party dependency under the hood.
final class RecursiveFolderEventsListener: FolderEventsListener {
    /// Underlying listeners for subfolders
    fileprivate var listeners: [String: FolderEventsListener] = [:]
    
    /// Internal 3rd party watcher
    fileprivate var watcher: FileWatch?
    
    /// Currently watching folder path
    fileprivate let folderPath: String
    
    /// Applied filters for watched events
    fileprivate let filter: FolderEventFilter?
    
    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput?
    
    init(folderPath: String, filter: FolderEventFilter? = nil) {
        self.filter = filter
        self.folderPath = folderPath
    }
    
    // MARK: - Interface
    
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
            strongSelf.process(received: folderEvent)
        }
    }
    
    func stopListening() {
        watcher = nil
    }
    
    // MARK: - Helpers
    
    func process(received event: FolderEvent) {
        switch event {
        case .created(let path, let object) where object == FolderEventObject.folder:
            let listener = RecursiveFolderEventsListener(folderPath: path, filter: filter)
            listener.output = output
            listeners[path] = listener
        case .deleted(let path, let object) where object == FolderEventObject.folder:
            listeners.removeValue(forKey: path)
        default: break
        }
    }
}
