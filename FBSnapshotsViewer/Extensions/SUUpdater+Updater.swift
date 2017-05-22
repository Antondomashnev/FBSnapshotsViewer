//
//  SUUpdater+Updater.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 21.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import Sparkle

extension SUUpdater: Updater {
    func checkForUpdates() {
        self.checkForUpdates(nil)
    }
}
