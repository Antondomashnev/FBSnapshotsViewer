//
//  MenuControllerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class MenuController_MockNSEvent: NSEvent {
    var mockedAssociatedEventsMask: NSEventMask!

    override var associatedEventsMask: NSEventMask {
        return mockedAssociatedEventsMask
    }
}

class MenuController_MockNSStatusBarButton: NSStatusBarButton {
    var imageSetCalled: Bool = false

    override var image: NSImage? {
        didSet {
            imageSetCalled = true
        }
    }
}

class MenuController_MockNSStatusItem: NSStatusItem {
    var popUpMenuCalled: (Bool, NSMenu)?
    var mockedButton: NSStatusBarButton!

    override var button: NSStatusBarButton? {
        return mockedButton
    }

    override func popUpMenu(_ menu: NSMenu) {
        popUpMenuCalled = (true, menu)
    }
}

class MenuController_MockStatusBar: NSStatusBar {
    var mockedStatusItem: NSStatusItem!

    override init() {
        super.init()
    }

    override func statusItem(withLength length: CGFloat) -> NSStatusItem {
        return mockedStatusItem
    }

    open override class func system() -> MenuController_MockStatusBar {
        return MenuController_MockStatusBar()
    }
}

class MenuControllerSpec: QuickSpec {
    override func spec() {
        var eventHandler: MenuModuleInterfaceMock!
        var menuController: MenuController!
        var statusItem: MenuController_MockNSStatusItem!
        var statusBar: MenuController_MockStatusBar!
        var button: MenuController_MockNSStatusBarButton!

        beforeEach {
            eventHandler = MenuModuleInterfaceMock()
            button = MenuController_MockNSStatusBarButton()
            statusItem = MenuController_MockNSStatusItem()
            statusBar = MenuController_MockStatusBar.system()
            statusBar.mockedStatusItem = statusItem
            statusItem.mockedButton = button
            menuController = MenuController(statusBar: statusBar)
            menuController.eventHandler = eventHandler
        }

        describe("menuStatusItemMenu.quitItemClicked") {
            beforeEach {
                menuController.menuStatusItemMenu(NSMenu(), quitItemClicked: NSMenuItem())
            }

            it("quits") {
                expect(eventHandler.quitCalled).to(beTrue())
            }
        }

        describe(".handleIconMouseEvent") {
            context("when rightMouseUp") {
                beforeEach {
                    let event = MenuController_MockNSEvent()
                    event.mockedAssociatedEventsMask = NSEventMask.rightMouseUp
                    menuController.handleIconMouseEvent(event)
                }

                it("shows application menu") {
                    expect(eventHandler.showApplicationMenuCalled).to(beTrue())
                }
            }

            context("when leftMouseUp") {
                beforeEach {
                    let event = MenuController_MockNSEvent()
                    event.mockedAssociatedEventsMask = NSEventMask.leftMouseUp
                    menuController.handleIconMouseEvent(event)
                }

                it("shows test results") {
                    expect(eventHandler.showTestResultsCalled).to(beTrue())
                }
            }
        }

        describe(".setNewTestResults") {
            context("when there are new test results") {
                beforeEach {
                    menuController.setNewTestResults(available: true)
                }

                it("updates status bar button image") {
                    expect(button.imageSetCalled).to(beTrue())
                }
            }

            context("when there are no new test results") {
                beforeEach {
                    menuController.setNewTestResults(available: false)
                }

                it("updates status bar button image") {
                    expect(button.imageSetCalled).to(beTrue())
                }
            }
        }

        describe(".popUpOptionsMenu") {
            beforeEach {
                menuController.popUpOptionsMenu()
            }

            it("shows menu") {
                expect(statusItem.popUpMenuCalled?.0).to(beTrue())
            }

            it("shows correct menu") {
                expect(statusItem.popUpMenuCalled?.1 is MenuStatusItemMenu).to(beTrue())
            }
        }
    }
}
