//
//  TestResultsWireframe.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

final class TestResultsWireframe {
    fileprivate var popover: NSPopover!
    fileprivate var userInterface: TestResultsController!
    
    func show(relativeTo rect: NSRect, of view: NSView) {
        userInterface = StoryboardScene.Main.instantiateTestResultsController()
        popover = NSPopover()
        popover.contentViewController = userInterface
        popover.show(relativeTo: rect, of: view, preferredEdge: NSRectEdge.minY)
    }
}
