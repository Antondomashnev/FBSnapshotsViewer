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
    private let listener = SnapshotsDiffFolderNotificationListener()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

