//
//  PreferencesModuleInterface.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 07.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol PreferencesModuleInterface: AutoMockable {
    func close()
    func updateUserInterface()
    func select(derivedDataFolderType: String)
    func update(derivedDataFolderPath: String)
}
