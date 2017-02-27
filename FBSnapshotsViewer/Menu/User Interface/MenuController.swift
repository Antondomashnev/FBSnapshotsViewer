//
//  Menu.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

final class MenuController {
    fileprivate let statusItem: NSStatusItem
    
    var eventHandler: MenuModuleInterface?
    
    init(statusBar: NSStatusBar) {
        statusItem = statusBar.statusItem(withLength: NSSquareStatusItemLength)
        if let button = statusItem.button {
            button.image = NSImage(named: "menu_icon")
            button.alternateImage = NSImage(named: "menu_icon_highlighted")
            button.action = #selector(showSnapshots(sender:))
            button.target = self
            
        }
    }
}

// MARK: - MenuUserInterface
extension MenuController:  MenuUserInterface {
    func setNewTestResults(available: Bool) {
        guard let button = statusItem.button else {
            return
        }
        button.image = NSImage(named: available ? "menu_icon_red" : "menu_icon")
    }
}

// MARK: - Actions
extension MenuController {
    @objc func showSnapshots(sender: AnyObject) {
        eventHandler?.showTestResults()
    }
}
