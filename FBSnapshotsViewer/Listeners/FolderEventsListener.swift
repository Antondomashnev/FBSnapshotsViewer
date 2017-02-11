//
//  FolderWatcher.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol FolderEventsListenerOutput: class {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive events: [FolderEvent])
}

protocol FolderEventsListener {

    /// Handler for `FolderEventsListener` output
    weak var output: FolderEventsListenerOutput? { get set }
    
    /// Designated initializer to create new instance of FolderEventsListener
    ///
    /// - Parameter folderPath: absolute folder path to watch
    init(folderPath: String)
}
