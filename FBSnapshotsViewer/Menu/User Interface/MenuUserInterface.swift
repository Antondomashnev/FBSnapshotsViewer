//
//  MenuUserInterface.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol MenuUserInterface: class {
    func setNewTestResults(available: Bool)
    func popUpOptionsMenu()
}
