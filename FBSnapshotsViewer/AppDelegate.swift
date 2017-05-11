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
        setUpConfiguration()
        let wireframe = MenuWireframe()
        menuUserInterface = wireframe.instantinateMenu(in: NSStatusBar.system())
    }

    func setUpConfiguration() {
        if AppProcessInfo.IsRunningTest {
            print("App is running tests, no need to setup configuration")
            return
        }
        let configurationStorage = UserDefaultsConfigurationStorage()
        if configurationStorage.loadConfiguration() != nil {
            print("App already has configuration stored")
        }
        else {
            print("Setting up the default configuration for app")
            configurationStorage.save(configuration: Configuration.default())
        }
    }
}
