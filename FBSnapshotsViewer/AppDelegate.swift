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
        if AppProcessInfo.IsRunningTest {
            print("App is running tests, skip app delegate")
            return
        }

        let cofiguration = setUpConfiguration()
        let wireframe = MenuWireframe()
        menuUserInterface = wireframe.instantinateMenu(in: NSStatusBar.system, configuration: cofiguration)
    }
    
    // MARK: - Helpers
    
    private func setUpConfiguration() -> Configuration {
        let configurationStorage = UserDefaultsConfigurationStorage()
        if let configuration = configurationStorage.loadConfiguration() {
            print("App already has configuration stored")
            return configuration
        }
        else {
            print("Setting up the default configuration for app")
            let defaltConfiguration = Configuration.default()
            configurationStorage.save(configuration: defaltConfiguration)
            return defaltConfiguration
        }
    }
}
