//
//  MenuStatusItemMenu.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuStatusItemMenuTarget: class {
    func menuStatusItemMenu(_ menu: NSMenu, quitItemClicked: NSMenuItem)
    func menuStatusItemMenu(_ menu: NSMenu, preferencesItemClicked: NSMenuItem)
    func menuStatusItemMenu(_ menu: NSMenu, checkForUpdatesItemClicked: NSMenuItem)
}

class MenuStatusItemMenu: NSMenu {
    private weak var target: MenuStatusItemMenuTarget?

    init(target: MenuStatusItemMenuTarget) {
        super.init(title: "Menu")
        self.target = target
        self.buildUp()
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    func buildUp() {
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitItemClicked(sender:)), keyEquivalent: "Q")
        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(preferencesItemClicked(sender:)), keyEquivalent: "P")
        let checkForUpdates = NSMenuItem(title: "Check for Updates", action: #selector(checkForUpdatesItemClicked(sender:)), keyEquivalent: "U")
        let items = [preferencesItem, checkForUpdates, quitItem]
        for item in items {
            item.target = self
            addItem(item)
        }
    }

    // MARK: - Actions

    @objc func preferencesItemClicked(sender: NSMenuItem) {
        target?.menuStatusItemMenu(self, preferencesItemClicked: sender)
    }

    @objc func quitItemClicked(sender: NSMenuItem) {
        target?.menuStatusItemMenu(self, quitItemClicked: sender)
    }

    @objc func checkForUpdatesItemClicked(sender: NSMenuItem) {
        target?.menuStatusItemMenu(self, checkForUpdatesItemClicked: sender)
    }
}
