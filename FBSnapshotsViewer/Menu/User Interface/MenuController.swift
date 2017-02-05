//
//  Menu.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

final class MenuController {
    private let statusItem: NSStatusItem
    
    init(statusBar: NSStatusBar) {
        statusItem = statusBar.statusItem(withLength: NSSquareStatusItemLength)
        if let button = statusItem.button {
            button.image = NSImage(named: "menu_icon")
            button.alternateImage = NSImage(named: "menu_icon_highlighted")
            button.action = #selector(showSnapshots)
        }
    }
}

// MARK: - Actions
extension MenuController {
    @objc func showSnapshots(sender: AnyObject) {
    }
}
