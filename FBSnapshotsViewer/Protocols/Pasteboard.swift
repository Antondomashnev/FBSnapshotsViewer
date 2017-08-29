//
//  Pasteboard.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 29.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import Cocoa

protocol Pasteboard: AutoMockable {
    func copyImage(at url: URL)
}

extension NSPasteboard: Pasteboard {
    func copyImage(at url: URL) {
        guard let image = NSImage(contentsOf: url) else {
            return
        }
        clearContents()
        writeObjects([image])
    }
}
