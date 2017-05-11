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
        NotificationCenter.default.addObserver(self, selector: #selector(derivedDataPathTextFieldDidChange(notification:)), name: Notification.Name.NSControlTextDidChange, object: derivedDataPathTextField)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        eventHandler.updateUserInterface()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        eventHandler.close()
    }
}

extension PreferencesController: PreferencesUserInterface {
    // MARK: - PreferencesUserInterface

    func show(preferencesDisplayInfo: PreferencesDisplayInfo) {
        setUpDerivedDataTypePopUpButton(with: preferencesDisplayInfo)
        setUpDerivedDataPathTextField(with: preferencesDisplayInfo)
        setUpDerivedDataPathLabel(with: preferencesDisplayInfo)
    }

    // MARK: - Helpers

    private func setUpDerivedDataPathLabel(with displayInfo: PreferencesDisplayInfo) {
        derivedDataPathLabel.stringValue = displayInfo.derivedDataFolderPath
    }

    private func setUpDerivedDataPathTextField(with displayInfo: PreferencesDisplayInfo) {
        derivedDataPathTextField.isEnabled = displayInfo.derivedDataFolderPathEditable
        derivedDataPathTextField.stringValue = displayInfo.derivedDataFolderPathEditable ? displayInfo.derivedDataFolderPath : ""
    }

    private func setUpDerivedDataTypePopUpButton(with displayInfo: PreferencesDisplayInfo) {
        derivedDataTypePopUpButton.removeAllItems()
        derivedDataTypePopUpButton.addItems(withTitles: displayInfo.derivedDataFolderTypeNames)
        derivedDataTypePopUpButton.selectItem(withTitle: displayInfo.derivedDataFolderTypeName)
    }
}

extension PreferencesController {
    // MARK: - Notifications

    @objc func derivedDataPathTextFieldDidChange(notification: Notification) {
        eventHandler.update(derivedDataFolderPath: derivedDataPathTextField.stringValue)
        derivedDataPathLabel.stringValue = derivedDataPathTextField.stringValue
    }
}

extension PreferencesController {
    // MARK: - Actions

    @IBAction func popUpValueChanged(_ sender: NSPopUpButton) {
        if let selectedTitle = sender.titleOfSelectedItem {
            eventHandler.select(derivedDataFolderType: selectedTitle)
        }
    }
}
