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
}

protocol PreferencesInteractorOutput: class, AutoMockable {

}
