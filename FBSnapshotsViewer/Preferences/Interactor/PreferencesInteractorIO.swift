//
//  PreferencesInteractorIO.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 10.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol PreferencesInteractorInput: class, AutoMockable {
    func save()
    func currentConfiguration() -> Configuration
    func setNewDerivedDataFolderType(_ type: String)
    func setNewDerivedDataFolderPath(_ path: String)
}
