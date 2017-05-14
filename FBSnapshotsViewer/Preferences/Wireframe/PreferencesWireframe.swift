//
//  PreferencesWireframe.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 07.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

class PreferencesModule {
    let moduleWindowController: NSWindowController
    let moduleInterface: PreferencesModuleInterface

    init(moduleWindowController: NSWindowController, moduleInterface: PreferencesModuleInterface) {
        self.moduleInterface = moduleInterface
        self.moduleWindowController = moduleWindowController
    }
}

class PreferencesWireframe {
    weak private var userInterface: PreferencesController?
    weak private var windowController: PreferencesWindowController!

    func show(withDelegate delegate: PreferencesModuleDelegate? = nil, configurationStorage: ConfigurationStorage = UserDefaultsConfigurationStorage()) -> PreferencesModule {
        windowController = StoryboardScene.Main.instantiatePreferencesWindowController()
        guard let controller = windowController.contentViewController as? PreferencesController, let window = windowController.window else {
            preconditionFailure("PreferencesWindowController doesn't have expected PreferencesController as a contentViewController or window is nil")
        }
        let interactor = PreferencesInteractor(configurationStorage: configurationStorage)
        let presenter = PreferencesPresenter()
        presenter.interactor = interactor
        presenter.userInterface = controller
        presenter.wireframe = self
        presenter.moduleDelegate = delegate
        controller.eventHandler = presenter
        userInterface = controller
        window.makeKeyAndOrderFront(nil)
        windowController.showWindow(nil)
        return PreferencesModule(moduleWindowController: windowController, moduleInterface: presenter)
    }
}
