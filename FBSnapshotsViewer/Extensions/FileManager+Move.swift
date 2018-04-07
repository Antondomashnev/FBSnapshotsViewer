//
//  FileManager+Move.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02.07.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

extension FileManager {
    func moveItem(at fromURL: URL, to toURL: URL) throws {
        try deleteItem(at: toURL)
        try self.copyItem(at: fromURL, to: toURL)
    }

    func deleteItem(at url: URL) throws {
        if fileExists(atPath: url.path) {
            try self.removeItem(at: url)
        }
    }
}
