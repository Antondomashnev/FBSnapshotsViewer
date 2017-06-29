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
        collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView, testResultCellDelegate: self)
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
    private func findTestResultInfo(for cell: TestResultCell) -> TestResultDisplayInfo? {
        let sectionInfos = collectionViewOutlets.testResultsDisplayInfo.sectionInfos
        guard let cellIndexPath = collectionView.indexPath(for: cell),
            sectionInfos.count > cellIndexPath.section,
            sectionInfos[cellIndexPath.section].itemInfos.count > cellIndexPath.item else {
                return nil
        }
        let testResultInfo = sectionInfos[cellIndexPath.section].itemInfos[cellIndexPath.item]
        return testResultInfo
    }
    
    func testResultCell(_ cell: TestResultCell, viewInKaleidoscopeButtonClicked: NSButton) {
        guard let testResultInfo = findTestResultInfo(for: cell) else {
            assertionFailure("Unexpected TestResultCellDelegate callback about Kaleidoscope button click")
            return
        }
        eventHandler.openInKaleidoscope(testResultDisplayInfo: testResultInfo)
    }
    
    func testResultCell(_ cell: TestResultCell, swapSnapshotsButtonClicked: NSButton) {
        guard let testResultInfo = findTestResultInfo(for: cell) else {
            assertionFailure("Unexpected TestResultCellDelegate callback about swap snapshots button click")
            return
        }
        eventHandler.swap([testResultInfo])
    }
}

extension TestResultsController: TestResultsHeaderDelegate {
    private func findTestResultsSectionDisplayInfo(for header: TestResultsHeader) -> TestResultsSectionDisplayInfo? {
        let sectionInfos = collectionViewOutlets.testResultsDisplayInfo.sectionInfos
        let headerBounds = header.convert(header.bounds, to: collectionView)
        guard let headerIndexPath = collectionView.indexPathForItem(at: CGPoint(x: headerBounds.midX, y: headerBounds.midY)),
            sectionInfos.count > headerIndexPath.section else {
                return nil
        }
        return sectionInfos[headerIndexPath.section]
    }
    
    func testResultsHeader(_ header: TestResultsHeader, swapSnapshotsButtonClicked: NSButton) {
        guard let testResultsSectionInfo = findTestResultsSectionDisplayInfo(for: header) else {
            assertionFailure("Unexpected TestResultsHeaderDelegate callback about swap snapshots button click")
            return
        }
        eventHandler.swap(testResultsSectionInfo.itemInfos)
    }
}

extension TestResultsController: TestResultsTopViewDelegate {
    func testResultsTopView(_ topView: TestResultsTopView, didSelect diffMode: TestResultsDiffMode) {
        eventHandler.selectDiffMode(diffMode)
    }
}
