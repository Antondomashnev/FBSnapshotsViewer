//
//  TestResultsControllerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 21/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import AppKit

@testable import FBSnapshotsViewer

class TestResultsController_MockNSCollectionView: NSCollectionView {
    var indexPathForItemReturnValue: IndexPath?
    override func indexPath(for item: NSCollectionViewItem) -> IndexPath? {
        return indexPathForItemReturnValue
    }

    var reloadDataCalled: Bool = false
    override func reloadData() {
        reloadDataCalled = true
    }
}

class TestResultsController_MockTestResultsCollectionViewOutlets: TestResultsCollectionViewOutlets {}

class TestResultsControllerSpec: QuickSpec {
    override func spec() {
        var collectionViewOutlets: TestResultsController_MockTestResultsCollectionViewOutlets!
        var collectionView: TestResultsController_MockNSCollectionView!
        var controller: TestResultsController!
        var eventHandler: TestResultsModuleInterfaceMock!

        beforeEach {
            collectionView = TestResultsController_MockNSCollectionView(frame: NSRect.zero)
            collectionViewOutlets = TestResultsController_MockTestResultsCollectionViewOutlets(collectionView: collectionView)
            eventHandler = TestResultsModuleInterfaceMock()
            controller = StoryboardScene.Main.instantiateTestResultsController()
            controller.eventHandler = eventHandler
            controller.collectionViewOutlets = collectionViewOutlets
            controller.collectionView = collectionView
        }

        describe(".show") {
            var testResults: [TestResultDisplayInfo]!

            beforeEach {
                let testResultDisplayInfo = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "Bla", referenceImagePath: "foo/bar.png", createdAt: Date(), applicationName: "MyApp"))
                testResults = [testResultDisplayInfo]
                controller.show(testResults: testResults)
            }

            it("reloads collection view") {
                expect(collectionView.reloadDataCalled).to(beTrue())
            }

            it("shows test results") {
                expect(collectionViewOutlets.testResults).to(equal(testResults))
            }
        }

        describe(".viewWillAppear") {
            beforeEach {
                controller.viewWillAppear()
            }

            it("updates user interface") {
                expect(eventHandler.updateUserInterfaceCalled).to(beTrue())
            }
        }

        describe(".testResultCell:viewInKaleidoscopeButtonClicked") {
            var cell: TestResultCell!
            var viewInKaleidoscopeButton: NSButton!

            beforeEach {
                viewInKaleidoscopeButton = NSButton(frame: NSRect.zero)
                cell = TestResultCell(nibName: nil, bundle: nil)
            }

            context("when cell is not visible") {
                beforeEach {
                    collectionView.indexPathForItemReturnValue = nil
                }

                it("asserts") {
                    expect { controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton) }.to(throwAssertion())
                }
            }

            context("when test result is not presented in controller") {
                beforeEach {
                    let testResultDisplayInfo = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "Bla", referenceImagePath: "foo/bar.png", createdAt: Date(), applicationName: "MyApp"))
                    collectionViewOutlets.testResults = [testResultDisplayInfo]
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 1, section: 0)
                }

                it("asserts") {
                    expect { controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton) }.to(throwAssertion())
                }
            }

            context("when test result is presented and cell is visible") {
                var testResultDisplayInfo: TestResultDisplayInfo!

                beforeEach {
                    testResultDisplayInfo = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "Bla", referenceImagePath: "foo/bar.png", createdAt: Date(), applicationName: "MyApp"))
                    collectionViewOutlets.testResults = [testResultDisplayInfo]
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 0, section: 0)
                    controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton)
                }

                it("opens test result in kaleidoscope") {
                    expect(eventHandler.openInKaleidoscopeCalled).to(beTrue())
                    expect(eventHandler.openInKaleidoscopeReceivedTestResultDisplayInfo).to(equal(testResultDisplayInfo))
                }
            }
        }
    }
}
