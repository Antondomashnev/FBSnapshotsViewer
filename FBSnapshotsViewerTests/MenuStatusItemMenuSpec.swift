//
//  MenuStatusItemMenuSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 06/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class MenuStatusItemMenu_MockMenuStatusItemMenuTarget: MenuStatusItemMenuTarget {
    var menuStatusItemMenuQuitItemClickedCalled: Bool = false

    func menuStatusItemMenu(_ menu: NSMenu, quitItemClicked: NSMenuItem) {
        menuStatusItemMenuQuitItemClickedCalled = true
    }
}

class MenuStatusItemMenuSpec: QuickSpec {
    override func spec() {
        var itemMenu: MenuStatusItemMenu!
        var target: MenuStatusItemMenu_MockMenuStatusItemMenuTarget!

        beforeEach {
            target = MenuStatusItemMenu_MockMenuStatusItemMenuTarget()
            itemMenu = MenuStatusItemMenu(target: target)
        }

        describe(".quitItemClicked") {
            beforeEach {
                itemMenu.quitItemClicked(sender: NSMenuItem(title: "Quit", action: nil, keyEquivalent: "Q"))
            }

            it("notifies target") {
                expect(target.menuStatusItemMenuQuitItemClickedCalled).to(beTrue())
            }
        }
    }
}
