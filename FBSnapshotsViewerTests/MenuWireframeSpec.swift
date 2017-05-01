//
//  MenuWireframeSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import AppKit

@testable import FBSnapshotsViewer

class MenuWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: MenuWireframe!

        beforeEach {
            wireframe = MenuWireframe()
        }

        describe("instantinateMenu(in:)") {
            var menuModule: MenuController!

            beforeEach {
                menuModule = wireframe.instantinateMenu(in: NSStatusBar.system()) as? MenuController
            }

            it("returns initialized module") {
                let presenter: MenuPresenter? = menuModule.eventHandler as? MenuPresenter
                let interactor: MenuInteractor? = presenter?.interactor as? MenuInteractor
                expect(menuModule).toNot(beNil())
                expect(presenter).toNot(beNil())
                expect(presenter?.wireframe).toNot(beNil())
                expect(presenter?.userInterface).toNot(beNil())
                expect(interactor).toNot(beNil())
                expect(interactor?.output).toNot(beNil())
            }
        }

        describe(".showTestResultsModule(with:)") {
            var menuModule: MenuController!

            beforeEach {
                menuModule = wireframe.instantinateMenu(in: NSStatusBar.system()) as? MenuController
            }

            it("doesnt crash") {
                wireframe.showTestResultsModule(with: [])
                print("\(menuModule)")
            }
        }
    }
}
