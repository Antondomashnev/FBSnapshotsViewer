//
//  MenuInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class MenuInteractor {
    private let snaphotsDiffFolderNotificationListener: SnapshotsDiffFolderNotificationListener
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsDiffFolderNotificationListener) {
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
    }
}
