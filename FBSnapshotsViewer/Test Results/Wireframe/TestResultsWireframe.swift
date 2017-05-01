//
//  TestResultsWireframe.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

final class TestResultsWireframe {

    func show(relativeTo rect: NSRect, of view: NSView, with testResults: [SnapshotTestResult]) {
        let userInterface = StoryboardScene.Main.instantiateTestResultsController()
        let interactor = TestResultsInteractor(testResults: testResults)
        let presenter = TestResultsPresenter()
        let popover = NSPopover()
        popover.behavior = .transient
        presenter.interactor = interactor
        presenter.userInterface = userInterface
        presenter.wireframe = self
        userInterface.eventHandler = presenter
        popover.contentViewController = userInterface
        popover.show(relativeTo: rect, of: view, preferredEdge: NSRectEdge.minY)
    }
}
