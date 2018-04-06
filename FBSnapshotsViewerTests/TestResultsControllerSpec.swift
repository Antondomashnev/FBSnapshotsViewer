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

class TestResultsController_MockTestResultsTopView: TestResultsTopView {
    var configureCalled = false
    var configureTestResultsDisplayInfo: TestResultsDisplayInfo?
    override func configure(with testResultsDisplayInfo: TestResultsDisplayInfo) {
        configureTestResultsDisplayInfo = testResultsDisplayInfo
        configureCalled = true
    }
}

class TestResultsController_MockTestResultsCollectionViewOutlets: TestResultsCollectionViewOutlets {}

class TestResultsControllerSpec: QuickSpec {
    override func spec() {
        let build: Build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
        var collectionViewOutlets: TestResultsController_MockTestResultsCollectionViewOutlets!
        var collectionView: TestResultsController_MockNSCollectionView!
        var controller: TestResultsController!
        var eventHandler: TestResultsModuleInterfaceMock!
        var testResults: [TestResultsSectionDisplayInfo] = []
        var testResultDisplayInfo: TestResultDisplayInfo!
        var topView: TestResultsController_MockTestResultsTopView!
        var displayInfo: TestResultsDisplayInfo!

        beforeEach {
            topView = TestResultsController_MockTestResultsTopView()
            collectionView = TestResultsController_MockNSCollectionView(frame: NSRect.zero)
            collectionViewOutlets = TestResultsController_MockTestResultsCollectionViewOutlets(collectionView: collectionView)
            eventHandler = TestResultsModuleInterfaceMock()
            controller = StoryboardScene.Main.instantiateTestResultsController()
            controller.eventHandler = eventHandler
            controller.collectionViewOutlets = collectionViewOutlets
            controller.collectionView = collectionView
            controller.topView = topView
            
            testResultDisplayInfo = TestResultDisplayInfo(testResult: SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "Bar", testName: "Bla", testFilePath: "foo/bar", testLineNumber: 1), referenceImagePath: "foo/bar.png", build: build))
            let titleInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "Foo")
            let sectionInfo = TestResultsSectionDisplayInfo(title: titleInfo, items: [testResultDisplayInfo])
            testResults = [sectionInfo]
            displayInfo = TestResultsDisplayInfo(sectionInfos: testResults, testResultsDiffMode: .mouseOver)
        }

        describe(".show") {
            beforeEach {
                controller.show(displayInfo: displayInfo)
            }

            it("reloads collection view") {
                expect(collectionView.reloadDataCalled).to(beTrue())
            }

            it("shows test results") {
                expect(collectionViewOutlets.testResultsDisplayInfo).to(equal(displayInfo))
            }
            
            it("configures top view") {
                expect(topView.configureCalled).to(beTrue())
                expect(topView.configureTestResultsDisplayInfo).to(equal(displayInfo))
            }
        }

        describe(".viewWillAppear") {
            beforeEach {
                controller.viewWillAppear()
            }

            it("updates user interface") {
                expect(eventHandler.updateUserInterface_Called).to(beTrue())
            }
        }
        
        describe(".testResultsTopView:didSelect") {
            beforeEach {
                controller.testResultsTopView(topView, didSelect: TestResultsDiffMode.diff)
            }
            
            it("selects diff mode") {
                expect(eventHandler.selectDiffMode___ReceivedDiffMode).to(equal(TestResultsDiffMode.diff))
            }
        }
        
        describe(".testResultCell:acceptSnapshotsButtonClicked") {
            var cell: TestResultCell!
            var acceptSnapshotsButton: NSButton!
            
            beforeEach {
                acceptSnapshotsButton = NSButton(frame: NSRect.zero)
                cell = TestResultCell(nibName: nil, bundle: nil)
            }
            
            context("when cell is not visible") {
                beforeEach {
                    collectionView.indexPathForItemReturnValue = nil
                }
                
                it("asserts") {
                    expect { controller.testResultCell(cell, acceptSnapshotsButtonClicked: acceptSnapshotsButton) }.to(throwAssertion())
                }
            }
            
            context("when test result is not presented in controller") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 1, section: 0)
                }
                
                it("asserts") {
                    expect { controller.testResultCell(cell, acceptSnapshotsButtonClicked: acceptSnapshotsButton) }.to(throwAssertion())
                }
            }
            
            context("when test result is presented and cell is visible") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 0, section: 0)
                    controller.testResultCell(cell, acceptSnapshotsButtonClicked: acceptSnapshotsButton)
                }
                
                it("accepts test result") {
                    expect(eventHandler.accept___Called).to(beTrue())
                    expect(eventHandler.accept___ReceivedTestResults).to(equal([testResultDisplayInfo]))
                }
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
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 1, section: 0)
                }

                it("asserts") {
                    expect { controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton) }.to(throwAssertion())
                }
            }

            context("when test result is presented and cell is visible") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 0, section: 0)
                    controller.testResultCell(cell, viewInKaleidoscopeButtonClicked: viewInKaleidoscopeButton)
                }

                it("opens test result in kaleidoscope") {
                    expect(eventHandler.openInKaleidoscope_testResultDisplayInfo_Called).to(beTrue())
                    expect(eventHandler.openInKaleidoscope_testResultDisplayInfo_ReceivedTestResultDisplayInfo).to(equal(testResults[0].itemInfos[0]))
                }
            }
        }
        
        describe(".testResultCell:viewInXcodeButtonClicked") {
            var cell: TestResultCell!
            var viewInXcodeButton: NSButton!
            
            beforeEach {
                viewInXcodeButton = NSButton(frame: NSRect.zero)
                cell = TestResultCell(nibName: nil, bundle: nil)
            }
            
            context("when cell is not visible") {
                beforeEach {
                    collectionView.indexPathForItemReturnValue = nil
                }
                
                it("asserts") {
                    expect { controller.testResultCell(cell, viewInXcodeButtonClicked: viewInXcodeButton) }.to(throwAssertion())
                }
            }
            
            context("when test result is not presented in controller") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 1, section: 0)
                }
                
                it("asserts") {
                    expect { controller.testResultCell(cell, viewInXcodeButtonClicked: viewInXcodeButton) }.to(throwAssertion())
                }
            }
            
            context("when test result is presented and cell is visible") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 0, section: 0)
                    controller.testResultCell(cell, viewInXcodeButtonClicked: viewInXcodeButton)
                }
                
                it("opens test result in xcode") {
                    expect(eventHandler.openInXcode_testResultDisplayInfo_Called).to(beTrue())
                    expect(eventHandler.openInXcode_testResultDisplayInfo_ReceivedTestResultDisplayInfo).to(equal(testResults[0].itemInfos[0]))
                }
            }
        }
        
        describe(".testResultCell:copySnapshotButtonClicked") {
            var cell: TestResultCell!
            var copySnapshotButton: NSButton!
            
            beforeEach {
                copySnapshotButton = NSButton(frame: NSRect.zero)
                cell = TestResultCell(nibName: nil, bundle: nil)
            }
            
            context("when cell is not visible") {
                beforeEach {
                    collectionView.indexPathForItemReturnValue = nil
                }
                
                it("asserts") {
                    expect { controller.testResultCell(cell, copySnapshotButtonClicked: copySnapshotButton) }.to(throwAssertion())
                }
            }
            
            context("when test result is not presented in controller") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 1, section: 0)
                }
                
                it("asserts") {
                    expect { controller.testResultCell(cell, copySnapshotButtonClicked: copySnapshotButton) }.to(throwAssertion())
                }
            }
            
            context("when test result is presented and cell is visible") {
                beforeEach {
                    collectionViewOutlets.testResultsDisplayInfo = displayInfo
                    collectionView.indexPathForItemReturnValue = IndexPath(item: 0, section: 0)
                    controller.testResultCell(cell, copySnapshotButtonClicked: copySnapshotButton)
                }
                
                it("opens test result in xcode") {
                    expect(eventHandler.copy_testResultDisplayInfo_Called).to(beTrue())
                    expect(eventHandler.copy_testResultDisplayInfo_ReceivedTestResultDisplayInfo).to(equal(testResults[0].itemInfos[0]))
                }
            }
        }
    }
}
