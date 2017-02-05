//
//  MenuWireframe.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

/// `MenuWireframe` is responsible to build a menu module - app's status bar UI representation
final class MenuWireframe {
    private weak var userInterface: MenuController?
    
    func instantinateMenu(in statusBar: NSStatusBar) {
        userInterface = MenuController(statusBar: statusBar)
    }
}
