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
    
    func show(relativeTo rect: CGRect, of view: NSView) {
        let popover = NSPopover()
        
    }
    
    // MARK: - Helpers
    
    private func createTestResultsUserInterface() throws -> TestResultsController {
        return NSStoryboard(name: "Main", bundle: Bundle.main).instantiateController(withIdentifier: "TestResultsController") as! TestResultsController
    }
}
