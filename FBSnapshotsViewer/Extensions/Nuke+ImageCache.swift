//
//  Nuke+ImageCache.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 01.07.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Nuke

extension Nuke.Cache: ImageCache {
    func invalidate() {
        self.removeAll()
    }
}
