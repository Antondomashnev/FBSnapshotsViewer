//
//  PreferencesController.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 07.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class PreferencesWindowController: NSWindowController {}

class PreferencesController: NSViewController {
    var eventHandler: PreferencesModuleInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        eventHandler.close()
    }
}

extension PreferencesController: PreferencesUserInterface {
}
