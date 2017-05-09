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
    @IBOutlet fileprivate weak var derivedDataTypePopUpButton: NSPopUpButton!
    @IBOutlet fileprivate weak var derivedDataPathLabel: NSTextField!
    @IBOutlet fileprivate weak var derivedDataPathTextField: NSTextField!

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

extension PreferencesController {
    // MARK: - Actions

    @IBAction func popUpValueChanged(_ sender: NSPopUpButton) {
        print("LAlala")
    }
}
