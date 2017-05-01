//
//  TestResultsWireframeSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 20/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: TestResultsWireframe!

        beforeEach {
            wireframe = TestResultsWireframe()
        }

        describe(".show") {
            let testResults: [SnapshotTestResult] = []
            var rect: NSRect!
            var view: NSView!

            beforeEach {
                rect = NSRect(x: 0, y: 0, width: 300, height: 300)
                view = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
                view.wantsLayer = true
                let window = NSWindow(contentRect: rect, styleMask: NSWindowStyleMask.borderless, backing: .retained, defer: false)
                window.contentView?.addSubview(view)
            }

            it("initializes the module") {
                expect(wireframe.show(relativeTo: rect, of: view, with: testResults)).toNot(throwAssertion())
            }
        }
    }
}
