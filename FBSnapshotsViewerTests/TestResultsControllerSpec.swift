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
        let build: Build = Build(date: Date(), applicationName: "FBSnapshotsViewer")
        var collectionViewOutlets: TestResultsController_MockTestResultsCollectionViewOutlets!
        var collectionView: TestResultsController_MockNSCollectionView!
        var controller: TestResultsController!
        var eventHandler: TestResultsModuleInterfaceMock!
        var testResults: [TestResultsSectionDisplayInfo] = []

        beforeEach {
            collectionView = TestResultsController_MockNSCollectionView(frame: NSRect.zero)
            collectionViewOutlets = TestResultsController_MockTestResultsCollectionViewOutlets(collectionView: collectionView)
            eventHandler = TestResultsModuleInterfaceMock()
            controller = StoryboardScene.Main.instantiateTestResultsController()
            controller.eventHandler = eventHandler
            controller.collectionViewOutlets = collectionViewOutlets
            controller.collectionView = collectionView
            
            let testResultDisplayInfo = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testName: "Bla", referenceImagePath: "foo/bar.png", build: build))
            let titleInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "Foo")
            let sectionInfo = TestResultsSectionDisplayInfo(title: titleInfo, items: [testResultDisplayInfo])
            testResults = [sectionInfo]
        }

        describe(".show") {
            beforeEach {
                controller.show(testResults: testResults)
            }

            it("reloads collection view") {
                expect(collectionView.reloadDataCalled).to(beTrue())
            }

            it("shows test results") {
                expect(collectionViewOutlets.testResultsSections).to(equal(testResults))
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
                    collectionViewOutlets.testResultsSections = testResults
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 1, section: 0)
                }

                it("asserts") {
                    expect { controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton) }.to(throwAssertion())
                }
            }

            context("when test result is presented and cell is visible") {
                beforeEach {
                    collectionViewOutlets.testResultsSections = testResults
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 0, section: 0)
                    controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton)
                }

                it("opens test result in kaleidoscope") {
                    expect(eventHandler.openInKaleidoscopeCalled).to(beTrue())
                    expect(eventHandler.openInKaleidoscopeReceivedTestResultDisplayInfo).to(equal(testResults[0].itemInfos[0]))
                }
            }
        }
    }
}
