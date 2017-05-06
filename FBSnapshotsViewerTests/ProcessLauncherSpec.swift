//
//  ProcessLauncherSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 06.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ProcessLauncherSpec: QuickSpec {
    override func spec() {
        describe("launch") {
            it("doesnt crash") {
                ProcessLauncher().launchProcess(at: "/bin/bash", with: ["option1", "option2"])
            }
        }
    }
}
