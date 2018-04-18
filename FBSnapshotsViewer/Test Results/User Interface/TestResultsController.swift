//
//  TestResultsController.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 28/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

class TestResultsController: NSViewController {
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet var topView: TestResultsTopView!
    var collectionViewOutlets: TestResultsCollectionViewOutlets!
    var eventHandler: TestResultsModuleInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        topView.delegate = self
        setupCollectionView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        eventHandler.updateUserInterface()
    }
    
    // MARK: - Helpers
    
    private func setupCollectionView() {
        collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView, testResultCellDelegate: self, testResultsHeaderDelegate: self)
        collectionView.delegate = collectionViewOutlets
        collectionView.dataSource = collectionViewOutlets
    }
}

extension TestResultsController: TestResultsUserInterface {
    func show(displayInfo: TestResultsDisplayInfo) {
        topView.configure(with: displayInfo)
        collectionViewOutlets.testResultsDisplayInfo = displayInfo
        collectionView.reloadData()
    }
}

extension TestResultsController: TestResultCellDelegate {
    private func findTestResultInfo(for cell: TestResultCell) -> (info: TestResultDisplayInfo, indexPath: IndexPath)? {
        let sectionInfos = collectionViewOutlets.testResultsDisplayInfo.sectionInfos
        guard let cellIndexPath = collectionView.indexPath(for: cell),
            sectionInfos.count > cellIndexPath.section,
            sectionInfos[cellIndexPath.section].itemInfos.count > cellIndexPath.item else {
                return nil
        }
        let testResultInfo = sectionInfos[cellIndexPath.section].itemInfos[cellIndexPath.item]
        return (testResultInfo, cellIndexPath)
    }
    
    private func openIn(_ eventHandlerFunction: (TestResultDisplayInfo) -> Void, from cell: TestResultCell) {
        guard let testResultInfo = findTestResultInfo(for: cell) else {
            assertionFailure("Unexpected TestResultCellDelegate callback about Xcode button click")
            return
        }
        eventHandlerFunction(testResultInfo.info)
    }
    
    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {
        openIn(eventHandler.openInKaleidoscope, from: cell)
    }
    
    func testResultCell(_ cell: TestResultCell, acceptSnapshotsButtonClicked: NSButton) {
        guard let testResultInfo = findTestResultInfo(for: cell) else {
            assertionFailure("Unexpected TestResultCellDelegate callback about accept snapshots button click")
            return
        }
        eventHandler.accept([testResultInfo.info])
        collectionView.reloadSections(IndexSet(integer: testResultInfo.indexPath.section))
    }
    
    func testResultCell(_ cell: TestResultCell, viewInXcodeButtonClicked: NSButton) {
        openIn(eventHandler.openInXcode, from: cell)
    }
    
    func testResultCell(_ cell: TestResultCell, copySnapshotButtonClicked: NSButton) {
        guard let testResultInfo = findTestResultInfo(for: cell) else {
            assertionFailure("Unexpected TestResultCellDelegate callback about copy snapshot button click")
            return
        }
        eventHandler.copy(testResultDisplayInfo: testResultInfo.info)
    }
}

extension TestResultsController: TestResultsHeaderDelegate {
    private func findTestResultsSectionDisplayInfo(for header: TestResultsHeader) -> (info: TestResultsSectionDisplayInfo, indexPath: IndexPath)? {
        let sectionInfos = collectionViewOutlets.testResultsDisplayInfo.sectionInfos
        let headerBounds = header.convert(header.frame, to: view)
        guard let headerIndexPath = collectionView.indexPathForItem(at: NSPoint(x: headerBounds.midX, y: headerBounds.midY)),
            sectionInfos.count > headerIndexPath.section else {
                return nil
        }
        return (sectionInfos[headerIndexPath.section], headerIndexPath)
    }
    
    func testResultsHeader(_ header: TestResultsHeader, acceptSnapshotsButtonClicked: NSButton) {
        guard let testResultsSectionInfo = findTestResultsSectionDisplayInfo(for: header) else {
            assertionFailure("Unexpected TestResultsHeaderDelegate callback about accept snapshots button click")
            return
        }
        eventHandler.accept(testResultsSectionInfo.info.itemInfos)
        collectionView.reloadSections(IndexSet(integer: testResultsSectionInfo.indexPath.section))
    }
}

extension TestResultsController: TestResultsTopViewDelegate {
    func testResultsTopView(_ topView: TestResultsTopView, didSelect diffMode: TestResultsDiffMode) {
        eventHandler.selectDiffMode(diffMode)
    }
}
