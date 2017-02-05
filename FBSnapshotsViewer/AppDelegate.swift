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
    private var menu: Menu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu = Menu(statusBar: NSStatusBar.system())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

