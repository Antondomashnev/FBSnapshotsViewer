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
        quitItem.target = self
        addItem(quitItem)
    }
    
    // MARK: - Actions
    
    @objc func quitItemClicked(sender: NSMenuItem) {
        target?.menuStatusItemMenu(self, quitItemClicked: sender)
    }
}
