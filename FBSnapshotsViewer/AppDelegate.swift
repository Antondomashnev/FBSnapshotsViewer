//
//  AppDelegate.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 29/01/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuUserInterface: MenuUserInterface!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let wireframe = MenuWireframe()
        menuUserInterface = wireframe.instantinateMenu(in: NSStatusBar.system())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
