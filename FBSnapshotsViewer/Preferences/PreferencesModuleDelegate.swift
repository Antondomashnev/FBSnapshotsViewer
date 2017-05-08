//
//  PreferencesModuleDelegate.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 08.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol PreferencesModuleDelegate: class {
    func preferencesModuleWillClose(_ preferencesModule: PreferencesModuleInterface)
}
