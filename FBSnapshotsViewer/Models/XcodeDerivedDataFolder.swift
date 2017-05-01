//
//  XcodeDerivedDataFolder.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 23.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct XcodeDerivedDataFolder: AutoEquatable {
    let path: String

    /// Default Xcode derived data folder
    static var `default`: XcodeDerivedDataFolder {
        return XcodeDerivedDataFolder(path: "\(NSHomeDirectory())/Library/Developer/Xcode/DerivedData")
    }
}
