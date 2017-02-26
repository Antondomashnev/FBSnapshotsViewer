//
//  ApplicationSnapshotTestImageCollectorFactory.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class ApplicationSnapshotTestImageCollectorFactory {
    // MARK: - Interface
    
    func applicationSnapshotTestImageCollector() -> ApplicationSnapshotTestImageCollector {
        return ApplicationSnapshotTestImageCollector()
    }
}
