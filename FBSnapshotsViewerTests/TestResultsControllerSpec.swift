//
//  TestResultsControllerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 21/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsControllerSpec: QuickSpec {
    override func spec() {
        var controller: TestResultsController!
        var eventHandler: TestResultsModuleInterfaceMock!

        beforeEach {
            eventHandler = TestResultsModuleInterfaceMock()
            controller = StoryboardScene.Main.instantiateTestResultsController()
            controller.eventHandler = eventHandler
        }

        describe(".viewWillAppear") {
            beforeEach {
                controller.viewWillAppear()
            }

            it("updates user interface") {
                expect(eventHandler.updateUserInterfaceCalled).to(beTrue())
            }
        }
    }
}
