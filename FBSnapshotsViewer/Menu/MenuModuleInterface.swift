//
//  MenuModuleInterface.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuModuleInterface: class, AutoMockable {
    func showTestResults()
    func showApplicationMenu()
    func quit()
}
