//
//  MenuModuleInterface.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuModuleInterface: class, AutoMockable {
    func start()
    func showTestResults()
    func showPreferences()
    func showApplicationMenu()
    func checkForUpdates()
    func quit()
}
