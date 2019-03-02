//
//  Menu.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

final class MenuController {
    let statusItem: NSStatusItem
    var eventHandler: MenuModuleInterface?

    init(statusBar: NSStatusBar) {
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(named: "menu_icon")
            button.alternateImage = NSImage(named: "menu_icon_highlighted")
            button.action = #selector(showSnapshots(sender:))
            button.target = self
            button.sendAction(on: NSEvent.EventTypeMask.leftMouseUp.union(NSEvent.EventTypeMask.rightMouseUp))
        }
    }
}

// MARK: - MenuUserInterface
extension MenuController: MenuUserInterface {
    func setNewTestResults(available: Bool) {
        statusItem.button?.image = NSImage(named: available ? "menu_icon_red" : "menu_icon")
    }

    func popUpOptionsMenu() {
        let menu = MenuStatusItemMenu(target: self)
        statusItem.popUpMenu(menu)
    }
}

// MARK: - Actions
extension MenuController: MenuActions {
    func handleIconMouseEvent(_ event: NSEvent) {
        let associatedEventsMask = event.associatedEventsMask
        if associatedEventsMask.contains(NSEvent.EventTypeMask.rightMouseUp) {
            eventHandler?.showApplicationMenu()
        }
        else if associatedEventsMask.contains(NSEvent.EventTypeMask.leftMouseUp) {
            eventHandler?.showTestResults()
        }
    }

    @objc func showSnapshots(sender: NSStatusBarButton) {
        if let event = NSApp.currentEvent {
            handleIconMouseEvent(event)
        }
    }
}

extension MenuController: MenuStatusItemMenuTarget {
    func menuStatusItemMenu(_ menu: NSMenu, quitItemClicked: NSMenuItem) {
        eventHandler?.quit()
    }

    func menuStatusItemMenu(_ menu: NSMenu, preferencesItemClicked: NSMenuItem) {
        eventHandler?.showPreferences()
    }

    func menuStatusItemMenu(_ menu: NSMenu, checkForUpdatesItemClicked: NSMenuItem) {
        eventHandler?.checkForUpdates()
    }
}
