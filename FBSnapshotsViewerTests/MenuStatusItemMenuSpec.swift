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

    var menuStatusItemMenuPreferencesItemClickedCalled: Bool = false
    func menuStatusItemMenu(_ menu: NSMenu, preferencesItemClicked: NSMenuItem) {
        menuStatusItemMenuPreferencesItemClickedCalled = true
    }

    var menuStatusItemMenuCheckForUpdatesItemClickedCalled: Bool = false
    func menuStatusItemMenu(_ menu: NSMenu, checkForUpdatesItemClicked: NSMenuItem) {
        menuStatusItemMenuCheckForUpdatesItemClickedCalled = true
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

        describe(".preferencesItemClicked") {
            beforeEach {
                itemMenu.preferencesItemClicked(sender: NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "P"))
            }

            it("notifies target") {
                expect(target.menuStatusItemMenuPreferencesItemClickedCalled).to(beTrue())
            }
        }

        describe(".checkForUpdatesItemClicked") {
            beforeEach {
                itemMenu.checkForUpdatesItemClicked(sender: NSMenuItem(title: "Check for Updates", action: nil, keyEquivalent: "U"))
            }

            it("notifies target") {
                expect(target.menuStatusItemMenuCheckForUpdatesItemClickedCalled).to(beTrue())
            }
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
